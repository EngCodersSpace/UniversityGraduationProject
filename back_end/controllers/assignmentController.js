
const {student,assignment, assignment_attachment,student_assignment,student_assignment_attachment} = require("../models");
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




