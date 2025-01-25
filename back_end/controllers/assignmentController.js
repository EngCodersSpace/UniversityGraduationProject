
const {student,assignment, assignment_file,student_assignment,student_assignment_file,user} = require("../models");
const { uploadFields, createFolderIfNotExists } = require('../utils/multerConfig');
const path = require('path');
const fs = require("fs");
const crypto = require('crypto');

// get assignments for specific subject of doctor  => 
// query (  level_id  section_id  and  subject_id)
exports.getAssignmentsOfSubject = async (req, res) => {
  try {
    if (req.user.permission === 'student' || 'representative') {
      const AllAssignmentSub = await assignment.findAll({
        where: {
          subject_id: req.query.subject_id,
          level_id: req.query.level_id,
          section_id: req.query.section_id,
        },
        include: [
          {
            model: student,
            where: { student_id: req.user.user_id },
            attributes: ['student_id'],
            through: {
              attributes: ['assignment_id', 'status', 'is_completed'],
            },
          },
        ],
      });

      res.status(200).json({
        message: 'Assignments retrieved successfully for student.',
        data: AllAssignmentSub,
      });
    } else if (req.user.permission === 'doctor' || 'lecturer') {
      const AllAssignmentSub = await assignment.findAll({
        where: {
          subject_id: req.query.subject_id,
          level_id: req.query.level_id,
          section_id: req.query.section_id,
        },
      });

      res.status(200).json({
        message: 'Assignments retrieved successfully for doctor.',
        data: AllAssignmentSub,
      });
    } else {
      res.status(403).json({
        message: 'Access denied. Only students and doctors can view this information.',
      });
    }
  } catch (error) {
    console.error('Error fetching assignments:', error);
    res.status(500).json({
      message: 'Error fetching assignments.',
      error: error.message,
    });
  }
};

// show all students of specific assignment... query assingment_id => to get all student 
exports.getAllStudentsOfAssignmentض=async (req,res)=>{
  try {
    const AllStudents = await student.findAll({
      include:[
        {
          model:assignment,
          where:{id:req.query.assignment_id},
          through:{
            attributes:['assignment_id','status','is_completed'],
          },
          include:[],
        }
      ],
    });    
    res.status(200).json({
      message: 'All Students retrieved successfully.',
      data: AllStudents,
    });
  } catch (error) {
    console.error('Error fetching students:', error);
    res.status(500).json({
      message: 'Error fetching students.',
      error: error.message,
    });
  }
};

// Get student files for a specific assignment
exports.getStudentFiles = async (req, res) => {
  try {
    const attachments = await student_assignment.findAll({
      where: { 
        assignment_id: req.query.assignment_id, 
        student_id: req.query.student_id ,
      },
      include: [
        {
          model: student_assignment_file,
          attributes: ['id', 'student_assignment_id', 'attachment', 'attachment_hash'],
        },
      ],
       
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

// 
exports.getStudentsAndFilesByAssignment = async (req, res) => {
  try {
    const assignmentDetails = await assignment.findOne({
      where: { id: req.query.assignment_id }, 
      include: [
        {
          model: student, 
          attributes: ['student_id'], 
          through: {
            attributes: ['status', 'is_completed'], 
          },
          include: [
            {
              model: student_assignment_file, 
              attributes: ['id', 'student_assignment_id', 'attachment', 'attachment_hash'],
            },
          ],
        },
      ],
    });

    if (!assignmentDetails) {
      return res.status(404).json({
        message: "No assignment found with the provided ID.",
      });
    }

    res.status(200).json({
      message: "Students and files retrieved successfully.",
      data: assignmentDetails,
    });
  } catch (error) {
    console.error("Error fetching data:", error);
    res.status(500).json({
      message: "Error fetching students and files.",
      error: error.message,
    });
  }
};


// download files of student_assignment 



exports.getFileDetails = async (req, res) => {
  try {
      const hash= crypto.createHash('md5').update(req.body.originalname + req.body.size + req.body.mimetype).digest('hex');

      const existingFile = await assignment_file.findOne({
        where: { attachment_hash: hash }, 
      });

      if (existingFile) {
        return res.status(400).json({message: 'This File is already uploaded.'});
      } else {
        return res.status(201).json({message: 'File ready to uploaded successfully.'});
      }
  } catch (error) {
    console.error('Error while checking file duplicates:', error.message);
    res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};


exports.uploadFilesForAssignment = async (req, res) => {
  try {
        uploadFields('assignments/doctors').array('files')(req, res, async (err) => {
          if (err) {
            return res.status(400).json({ message: 'Error during file upload.', error: err.message });
          }

          const assignmentFiles = req.newFiles.map((file) => ({
            assignment_id: req.query.assignment_id,
            attachment: file.path,
            attachment_hash: file.hash,
          }));

          await assignment_file.bulkCreate(assignmentFiles);

          res.status(200).json({
            message: 'File processing completed.',
            duplicates: req.duplicateFiles || [],
            newFiles: req.newFiles || [],
          });
        });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error.' , error: err.message });
  }
};




exports.createAssignment = async (req, res) => {
  try {
    const sectionsAndLevels = req.body.sectionsAndLevels; 

    if (!req.body.sectionsAndLevels || req.body.sectionsAndLevels.length === 0) {
      return res.status(400).json({ message: 'No sections and levels provided.' });
    }

    const createdAssignments = [];

    for (const { section_id, level_id } of sectionsAndLevels) {
      const assignmentRecord = await assignment.create({
        subject_id: req.body.subject_id,
        doctor_id: req.user.user_id,
        title: req.body.title,
        assignment_due_day: req.body.assignment_due_day,
        assignment_date: req.body.assignment_date,
        assignments_due_date: req.body.assignments_due_date,
        section_id: section_id,
        level_id: level_id,
      });

      const Students = await student.findAll({
        where: { student_level_id: level_id },
        include: [
          {
            model: user,
            as: 'user',
            where: { user_section_id: section_id },
            attributes: [],
          },
        ],
      });

      const studentAssignments = Students.map((student) => ({
        student_id: student.student_id,
        assignment_id: assignmentRecord.id,
        status: 'not submitted',
        is_completed: false,
      }));

      await student_assignment.bulkCreate(studentAssignments);

      createdAssignments.push(assignmentRecord);
    }

    res.status(200).json({
      message: 'Assignments created successfully for the specified sections and levels.',
      data: createdAssignments,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: 'Error creating assignments.',
      error: error.message,
    });
  }
};


// when student upload files of specific assignment attachement
exports.uploadFilesAttachment = [
  uploadFields('assignments/students').array('files'), 
  async (req, res) => {
    try {
      if (!req.files || req.files.length === 0) {
        return res.status(400).json({ message: 'No files uploaded.' });
      }
      const studentAssignment = await student_assignment.findOne({
        where: {
          student_id: req.user.user_id,
          assignment_id: req.body.assignment_id,
        },
      });

      if (!studentAssignment) {
        return res.status(404).json({ message: 'Student assignment not found.' });
      }

      const studentFiles = [];
      for (const file of req.files) {
        const hash = crypto.createHash('md5').update(
          `${file.originalname}-${Date.now()}`
        ).digest('hex');

        const fileExtension = path.extname(file.originalname);
        const fileName = `${hash}${fileExtension}`;
        const finalFilePath = path.join(__dirname,'../storage/assignments', 'students', fileName);

        await createFolderIfNotExists(path.dirname(finalFilePath));

        studentFiles.push({
          student_assignment_id: studentAssignment.id,
          attachment: finalFilePath,
          attachment_hash: hash,
        });
       
      }

      await student_assignment_file.bulkCreate(studentFiles);

      res.status(200).json({
        message: `Files uploaded successfully for assignment ${req.body.assignment_id}`,
        data:  studentFiles,
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error uploading files for assignment.', error: error.message });
    }
  },
];


// Doctor updates the status of a student's assignment (4)
exports.updateAssignmentStatus = async (req, res) => {
  try {
    const { studentAssignmentId, status } = req.query;

    const studentAssignment = await student_assignment.findOne({
      where: { id: studentAssignmentId },
    });

    if (!studentAssignment) {
      return res.status(404).json({ message: 'Student assignment not found.' });
    }

    studentAssignment.status = status;
    await studentAssignment.save();

    res.status(200).json({
      message: `Assignment status updated to "${status}" successfully.`,
      data: { studentAssignment },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error updating assignment status.', error: error.message });
  }
};

// Function to update student assignment complete by the student
exports.updateStudentComplete = async (req, res) => {
  try {
    const studentAssignment = await student_assignment.findOne({
      where: { id: req.query.student_assignment_id , student_id : req.query.student_id },
    });

    studentAssignment.is_completed = req.query.is_completed;
    await studentAssignment.save();

    res.status(200).json({
      message: `Student assignment is_complete updated successfully to ${req.query.is_completed}`,
      data: studentAssignment,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Error updating student assignment is_completed.",
      error: error.message,
    });
  }
};

// for doctor
exports.updateAssigment=async(req,res)=>{
  try {
    const Assignment = await assignment.findOne({
      where:{id:req.body.assignment_id},
    });

    if (!Assignment) {
      return res.status(404).json({ message: 'Assignment not found.' });
    }

    const updatedFields = {
      subject_id: req.body.subject_id || Assignment.subject_id,
      assignment_due_day: req.body.assignment_due_day || Assignment.assignment_due_day,
      assignment_date: req.body.assignment_date || Assignment.assignment_date,
      assignments_due_date: req.body.assignments_due_date || Assignment.assignments_due_date,
      title: req.body.title || Assignment.title,
      section_id: req.body.section_id || Assignment.section_id,
      level_id: req.body.level_id || Assignment.level_id,
    };

    await Assignment.update(updatedFields, { where: { id: req.query.assignment_id } });

    res.status(200).json({
      message: `Assignment is updated successfully to `,
      data: Assignment,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Error updating  Assignment ",
      error: error.message,
    });
  }
};


// Doctor  deletes an assignment with thier files  
exports.deleteAssignment = async (req, res) => {
  try {
    const Assignment = await assignment.findByPk(req.query.assignment_id);
    if (!Assignment) {
      return res.status(404).json({ message: 'Assignment not found.' });
    }
    const AssignFiles= await assignment_file.findAll({
      where:{assignment_id: Assignment.id},
    });

    for (const file of AssignFiles) {
      const attachmentPath = path.resolve(file.attachment);
      if (fs.existsSync(attachmentPath)) {
        await fs.promises.unlink(attachmentPath);
        console.log(`Deleted file: ${attachmentPath}`);
      } else {
        console.warn(`File not found: ${attachmentPath}`);
      }
      await file.destroy();
    }

    await Assignment.destroy();
    res.status(200).json({ message: 'Assignment deleted successfully.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error deleting assignment.', error: error.message });
  }
};

// doctor or student only deletes file's assignment 
exports.deleteAssigmentFiles=async(req,res)=>{
  try {
    const AssignFiles= await assignment_file.findAll({
      where:{assignment_id: req.query.assignment_id},
    });

    for (const file of AssignFiles) {
      const attachmentPath = path.resolve(file.attachment);
      if (fs.existsSync(attachmentPath)) {
        await fs.promises.unlink(attachmentPath);
        console.log(`Deleted file: ${attachmentPath}`);
      } else {
        console.warn(`File not found: ${attachmentPath}`);
      }
    }

    res.status(200).json({ message: 'Assignment files deleted successfully.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error deleting assignment files.', error: error.message });
  }
};





