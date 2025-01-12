
const {student,assignment} = require("../models");
const { uploadFields  } = require('../utils/multerConfig');
const path = require('path');
const fs = require("fs");

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


exports.uploadAssigment =[
uploadFields,
  async (req,res)=> {
    try {
      if (!req.files || !req.files['files'] || req.files['files'].length === 0) {
        return res.status(400).json({ message: "No files uploaded." });
      }
      const uploadedAssignments = [];
      for (const file of req.files['files']) {
        const tempFilePath = file.path;
        const finalFilePath = path.join(__dirname, '../storage/assignments',req.body.subject_id,file.originalname);

        const Assignments= assignment.create({
          subject_id:req.body.subject_id,
          doctor_id:req.user.user_id,
          title:req.body.title,
          assignment_day:req.body.assignment_day,
          assignment_date:req.body.assignment_date,
          assignments_due_date:req.body.assignments_due_date,
          attachment:finalFilePath,
        });

        const directory = path.dirname(finalFilePath);
        if (!fs.existsSync(directory)) {
          fs.mkdirSync(directory, { recursive: true });
        }
        fs.renameSync(tempFilePath, finalFilePath);
        uploadedAssignments.push(Assignments);
      }

      if (uploadedAssignments.length === 0) {
        return res.status(400).json({ message: "No valid books were uploaded." });
      }
      res.status(200).json({ message: "Assignments retrieved successfully" });
    } catch(error){
      console.error(error);
      res.status(500).json({ message: "Error retrieving assignments", error: error.message });
    }
  }
];

  