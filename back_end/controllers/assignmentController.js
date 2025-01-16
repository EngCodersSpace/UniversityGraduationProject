
const {student,assignment, assignment_attachment,student_assignment,student_assignment_attachment,user} = require("../models");
const { uploadFields  } = require('../utils/multerConfig');
const path = require('path');
const fs = require("fs");
const crypto = require('crypto');

exports.getAssignmentsBySubject = async (req, res) => {
    try {
      const assignments = await assignment.findAll({
        where: { subject_id:req.query.subject_id },
        include: [
          {
            model: student, 
            attributes: [], 
            // through:{ attributes: [] },
            through: {
                attributes: ["status", "attachment"], 
                where: { student_id:req.user.user_id }, 
            },
          },
        ]
      });
  
      if (!assignments.length) {
        return res.status(404).json({ message: "No assignments found for this subject." });
      }
  
      res.status(200).json({ message: "Assignments retrieved successfully", data: assignments });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Error retrieving assignments", error: error.message });
    }
};

// Doctor uploads files for an assignment
exports.uploadAssignmentByDoctor = [
  uploadFields,
  async (req, res) => {
    try {
      if (!req.files || !req.files['files'] || req.files['files'].length === 0) {
        return res.status(400).json({ message: "No files uploaded." });
      }

      const assignmentRecord = await assignment.create({
        subject_id: req.body.subject_id,
        doctor_id: req.user.user_id,
        title: req.body.title,
        assignment_due_day: req.body.assignment_due_day,
        assignment_date: req.body.assignment_date,
        assignments_due_date: req.body.assignments_due_date,
      });

      const Students = await student.findAll({
        where: { student_level_id: req.body.level_id },
        include: [
          {
            model: user,
            as: 'user',
            where: { user_section_id: req.body.section_id },
            attributes: [],
          },
        ],
      });

      if (Students.length === 0) {
        return res.status(400).json({ message: "No students found for the specified level and section." });
      }

      const studentAssignments = [];
      for (const student of Students) {
        const studentAssignment = await student_assignment.create({
          student_id: student.student_id,
          assignment_id: assignmentRecord.id,
          status: false,
        });

        studentAssignments.push(studentAssignment);
      }

      const assignmentAttachments = [];
      for (const file of req.files['files']) {
        const tempFilePath = file.path;
        const hash = crypto.createHash('md5').update(
          `${req.body.subject_id}-${file.originalname}-${req.user.user_id}-${Date.now()}`
        ).digest('hex');

        const fileExtension = path.extname(tempFilePath);
        const fileName = `${hash}${fileExtension}`;
        const finalFilePath = path.join(__dirname, '../storage/assignments', 'doctors', fileName);

        const directory = path.dirname(finalFilePath);
        if (!fs.existsSync(directory)) {
          await fs.promises.mkdir(directory, { recursive: true });
        }

        fs.renameSync(tempFilePath, finalFilePath);

        assignmentAttachments.push({
          assignment_id: assignmentRecord.id,
          attachment: finalFilePath,
          attachment_hash: hash,
        });
      }

      await assignment_attachment.bulkCreate(assignmentAttachments);

      res.status(200).json({
        message: `Assignment created successfully with ${assignmentAttachments.length} attachment(s) and assigned to ${studentAssignments.length} student(s).`,
        data: {
          assignment: assignmentRecord,
          studentAssignments: studentAssignments,
        },
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Error uploading assignment", error: error.message });
    }
  }
];

// Student uploads files for an assignment
exports.uploadReportByStudent = [
  uploadFields,
  async (req, res) => {
    try {
      if (!req.files || !req.files['files'] || req.files['files'].length === 0) {
        return res.status(400).json({ message: "No files uploaded." });
      }

      const studentAssignment = await student_assignment.findOne({
        where: {
          assignment_id: req.query.assignment_id,
          student_id: req.user.user_id,
        },
      });

      if (!studentAssignment) {
        return res.status(404).json({ message: "Assignment not found for the student." });
      }

      const studentAttachments = [];
      for (const file of req.files['files']) {
        const tempFilePath = file.path;
        const hash = crypto.createHash('md5').update(
          `${req.query.assignment_id}-${file.originalname}-${req.user.user_id}`
        ).digest('hex');

        const fileExtension = path.extname(tempFilePath);
        const fileName = `${hash}${fileExtension}`;
        const finalFilePath = path.join(__dirname, '../storage/library','students', fileName);

        const directory = path.dirname(finalFilePath);
        if (!fs.existsSync(directory)) {
          await fs.promises.mkdir(directory, { recursive: true });
        }

        fs.renameSync(tempFilePath, finalFilePath);

        studentAttachments.push({
          student_assignment_id: studentAssignment.id,
          attachment: finalFilePath,
          attachment_hash: hash,
        });
      }

      await student_assignment_attachment.bulkCreate(studentAttachments);

      res.status(200).json({
        message: `${studentAttachments.length} file(s) uploaded successfully.`,
        data: studentAttachments,
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Error uploading files", error: error.message });
    }
  }
];




// Get student attachments for a specific assignment
exports.getStudentAttachments = async (req, res) => {
  try {
    const { assignment_id } = req.query;
    if (!assignment_id) {
      return res.status(400).json({ message: "Assignment ID is required." });
    }
    const attachments = await student_assignment_attachment.findAll({
      include: [
        {
          model: student_assignment,
          as: 'student_assignment',
          include: [
            {
              model: assignment,
              as: 'assignment', 
              where: { id: assignment_id },
            },
            {
              model: student,
              as: 'student', 
              include: [
                {
                  model: user,
                  as: 'user', 
                  attributes: [],
                },
              ],
            },
          ],
        },
      ],
      attributes: ['id', 'attachment', 'attachment_hash'],
    });
    
    

    if (attachments.length === 0) {
      return res.status(404).json({ message: "No attachments found for this assignment." });
    }

    res.status(200).json({
      message: `Found ${attachments.length} attachment(s) for the assignment.`,
      data: attachments,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error retrieving attachments.", error: error.message });
  }
};

// Function to update student assignment status by the doctor
exports.updateStudentAssignmentStatus = async (req, res) => {
  try {
    const { student_assignment_id, status } = req.body;

    // Ensure the required fields are provided
    if (!student_assignment_id || typeof status !== "boolean") {
      return res.status(400).json({
        message: "Invalid input. Provide 'student_assignment_id' and 'status'.",
      });
    }

    // Find the student assignment record
    const studentAssignment = await student_assignment.findOne({
      where: { id: student_assignment_id },
    });

    if (!studentAssignment) {
      return res.status(404).json({
        message: "Student assignment record not found.",
      });
    }

    // Update the status
    studentAssignment.status = status;
    await studentAssignment.save();

    res.status(200).json({
      message: `Student assignment status updated successfully to ${
        status ? "approved" : "not approved"
      }.`,
      data: studentAssignment,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Error updating student assignment status.",
      error: error.message,
    });
  }
};







