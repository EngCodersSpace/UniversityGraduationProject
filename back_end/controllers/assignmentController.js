
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

// for doctor
exports.uploadAssignment = [
  uploadFields,
  async (req, res) => {
    try {
      if (!req.files || !req.files['files'] || req.files['files'].length === 0) {
        return res.status(400).json({ message: "No files uploaded." });
      }

      const uploadedAssignments = [];
      const uploadAssignmentAttachment = [];

      for (const file of req.files['files']) {
        const tempFilePath = file.path;
        const hash = crypto.createHash('md5').update(
          `${req.body.subject_id}-${file.originalname}-${req.user.user_id}-${req.body.assignment_due_day}`
        ).digest('hex');

        const fileExtension = path.extname(tempFilePath);
        const fileName = `${hash}${fileExtension}`;
        const finalFilePath = path.join(__dirname, '../storage/assignments', fileName);

        const assignmentRecord = await assignment.create({
          subject_id: req.body.subject_id,
          doctor_id: req.user.user_id,
          title: req.body.title,
          assignment_due_day: req.body.assignment_due_day,
          assignment_date: req.body.assignment_date,
          assignments_due_date: req.body.assignments_due_date,
        });

        const assignAttach = await assignment_attachment.create({
          assignment_id: assignmentRecord.id,
          attachment: finalFilePath,
          attachment_hash: hash,
        });
        
        const directory = path.dirname(finalFilePath);
        if (!fs.existsSync(directory)) {
          await fs.promises.mkdir(directory, { recursive: true });
        }

        fs.renameSync(tempFilePath, finalFilePath);

        const Students = await student.findAll({
          where: { student_level_id : req.body.level_id},
          include:[
            { model:user,as:'user',
              where :{user_section_id : req.body.section_id},
              attributes:[],
            },
          ]
        });
    
        if (Students.length === 0) {
          continue;;
        }

        const studentAssignments = [];
        const studentAssignmentAttachments = [];

        for (const student of Students) {
          const studentAssignment = await student_assignment.create({
            student_id: student.student_id,
            assignment_id: assignmentRecord.id,
            status: false,
          });

          studentAssignments.push(studentAssignment);

          const studentAttachment = {
            student_assignment_id: studentAssignment.id,
            attachment: finalFilePath,
            attachment_hash: hash,
          };
          studentAssignmentAttachments.push(studentAttachment);
        }

        await student_assignment_attachment.bulkCreate(studentAssignmentAttachments);

        uploadedAssignments.push(assignmentRecord);
        uploadAssignmentAttachment.push(assignAttach);
      }

      if (uploadedAssignments.length === 0) {
        return res.status(400).json({ message: "No valid assignments were uploaded." });
      }

      res.status(200).json({
        message: `${uploadedAssignments.length} assignment(s) uploaded successfully.`,
        data: uploadedAssignments
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Error uploading assignments", error: error.message });
    }
  }
];






// assign a task to some students      deleted 
exports.assignTaskToStudents =async (req , res) => {
  try {
    const Students = await student.findAll({
      where: {section_id : req.body.section_id, level_id : req.body.level_id},
    });

    if (Students.length === 0) {
      console.log('');
      return;
    }

    const assignments = Students.map((student) => ({
      student_id: student.student_id,
      assignment_id: req.body.assignment_id,
      status: false, 
    }));

    await student_assignment.bulkCreate(assignments);

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error retrieving student assignment", error: error.message });
  }
};





