
const {student,assignment, assignment_file,student_assignment,student_assignment_file,user, level} = require("../models");
const { uploadFields  } = require('../utils/multerConfig');
const path = require('path');
const fs = require("fs");
const crypto = require('crypto');

// Fetch all assignments of specific subject for a student based on level and section
// query (  level_id  and  subject_id)   get section_id from user 
exports.getStudentAssignments = async (req, res) => {
  try {
    const userData = await user.findOne({
      where: { user_id: req.user.user_id },
    });

    const assignments = await assignment.findAll({
      where: { subject_id: req.query.subject_id },
      include: [
        {
          model: student,
          attributes: ['student_id'],
          through: { attributes: ['assignment_id', 'status', 'is_completed'] },
          where: {
            student_id: req.user.user_id,
            student_level_id: req.query.level_id,
          },
          include: [
            {
              model: user,
              as: 'user',
              attributes: ['user_name'],
              where: { user_section_id: userData.user_section_id },
            },
          ],
        },
      ],
    });

    // Respond with assignments
    res.status(200).json({
      message: 'Assignments retrieved successfully.',
      data: assignments,
    });
  } catch (error) {
    console.error('Error fetching assignments:', error);
    res.status(500).json({
      message: 'Error fetching assignments.',
      error: error.message,
    });
  }
};

// get assignments for specific subject of doctor  => 
// query (  level_id  section_id  and  subject_id)
exports.getAssignmentsOfSubject=async (req,res)=>{
  try {
    const AllAssignmentSub=await assignment.findAll({
      where:{ subject_id :req.query.subject_id},
      include:[
        {
          model: student,
          attributes: ['student_id'],
          through: { attributes: ['assignment_id', 'status', 'is_completed'] },
          where: {
            student_level_id: req.query.level_id,
          },
          include: [
            {
              model: user,
              as: 'user',
              attributes: ['user_name'],
              where: { user_section_id: req.query.section_id },
            },
          ],
        },
      ],
    });

    res.status(200).json({
      message: 'Assignments retrieved successfully.',
      data: AllAssignmentSub,
    });
  } catch (error) {
    console.error('Error fetching assignments:', error);
    res.status(500).json({
      message: 'Error fetching assignments.',
      error: error.message,
    });
  }
};

// query assingment_id => to get all student 
exports.getAllStudentsOfAssignment=async (req,res)=>{
  try {
    const AllStudents = await student.findAll({
      include:[
        {
          model:assignment,
          through:{
            attributes:['assignment_id','status','is_completed'],
            where:{assignment_id:req.query.assignment_id},
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
    const attachments = await student_assignment_file.findAll({
      include: [
        {
          model: student_assignment,
          as: 'student_assignment',
          include: [
            {
              model: assignment,
              as: 'assignment', 
              where: { id: req.query.assignment_id },
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
      attributes: ['id','student_assignment_id', 'attachment', 'attachment_hash'],
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


exports.getCountAssignmentForSubject = async (req, res) => {
  try {
    const assignments = await student_assignment.findAll({
      where: { student_id: req.user.user_id },
      include: [{
        model: assignment,
        where: { subject_id: req.query.subject_id }, 
        required: true, 
      }],
    });

    if (!assignments || assignments.length === 0) {
      return res.status(404).json({ message: 'No assignments found for the specified student and subject.' });
    }

    let completedCount = 0;
    let totalCount = assignments.length;

    for (const assignment of assignments) {
      if (assignment.is_completed === 1) {
        completedCount++;
      }
    }

    res.status(200).json({
      message: `you finished :${completedCount} / ${totalCount} `,
      data: {completedCount,totalCount}
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error fetching assignment stats.', error: error.message });
  }
};


// for doctor upload
exports.uploadFilesForAssignment = [
  uploadFields,
  async (req, res) => {
    try {
      if (!req.files || !req.files['files'] || req.files['files'].length === 0) {
        return res.status(400).json({ message: 'No files uploaded.' });
      }

      const assignmentFiles = [];
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

        assignmentFiles.push({
          assignment_id: req.body.assignment_id,
          attachment: finalFilePath,
          attachment_hash: hash,
        });
      }

      await assignment_file.bulkCreate(assignmentFiles);

      await assignment.update({ files_uploaded: true }, { where: { id: req.body.assignment_id } });

      res.status(200).json({
        message: `Files uploaded successfully for assignment ${req.body.assignment_id}`,
        data: { files: assignmentFiles },
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error uploading files for assignment.', error: error.message });
    }
  },
];


// Doctor creates an assignment
exports.createAssignment = async (req, res) => {
  try {
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
      include: [{
        model: user,
        as: 'user',
        where: { user_section_id: req.body.section_id },
        attributes: [],
      }],
    });

    const studentAssignments = [];
    for (const student of Students) {
      const studentAssignment = await student_assignment.create({
        student_id: student.student_id,
        assignment_id: assignmentRecord.id,
        status: 'not submitted',
        is_completed: false,
      });
      studentAssignments.push(studentAssignment);
    };


    uploadFields(req, res, async (err) => {
      try {
        if (err) {
          return res.status(500).json({ message: 'Error uploading files.', error: err.message });
        }
    
        const assignmentFiles = [];
        const failedFiles = [];
    
        if (req.files['files'] && req.files['files'].length > 0) {
          for (const file of req.files['assignmentFiles']) {
            try {
              const fileName = file.filename;
              const filePath = path.join(__dirname, '../storage/assignments', 'doctors', fileName);
    
              fs.renameSync(file.path, filePath);
    
              assignmentFiles.push({
                assignment_id: assignmentRecord.id,
                attachment: filePath,
                attachment_hash: fileName, 
              });
            } catch (error) {
              failedFiles.push({ fileName: file.originalname, error: error.message });
            }
          }
        }
    
        if (assignmentFiles.length > 0) {
          await assignment_file.bulkCreate(assignmentFiles);
        }
    
        res.status(200).json({
          message: 'Assignment created successfully.',
          data: { assignment: assignmentRecord, assignmentFiles, failedFiles },
        });
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error creating assignment or uploading files.', error: error.message });
      }
    });
    
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error creating assignment.', error: error.message });
  }
};


// for student upload
exports.uploadStudentFiles = [
  uploadFields,
  async (req, res) => {
    try {
      if (!req.files || !req.files['files'] || req.files['files'].length === 0) {
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
      for (const file of req.files['files']) {
        const tempFilePath = file.path;
        const hash = crypto.createHash('md5').update(
          `${req.body.assignment_id}-${req.user.user_id}-${file.originalname}-${Date.now()}`
        ).digest('hex');

        const fileExtension = path.extname(tempFilePath);
        const fileName = `${hash}${fileExtension}`;
        const finalFilePath = path.join(__dirname, '../storage/assignments', 'students', fileName);

        const directory = path.dirname(finalFilePath);
        if (!fs.existsSync(directory)) {
          await fs.promises.mkdir(directory, { recursive: true });
        }

        fs.renameSync(tempFilePath, finalFilePath);

        studentFiles.push({
          student_assignment_id: studentAssignment.id,
          attachment: finalFilePath,
          attachment_hash: hash,
        });
      }

      await student_assignment_file.bulkCreate(studentFiles);

      await student_assignment.update(
        {is_completed: req.query.is_completed },
        { where: { id: studentAssignment.id } }
      );

      res.status(200).json({
        message: `Files uploaded successfully for student assignment ${studentAssignment.id}`,
        data: { files: studentFiles },
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error uploading student files.', error: error.message });
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
    const Assignment = await assignment.findByPk({id:req.query.assignment_id});
    if (!Assignment) {
      return res.status(404).json({ message: 'Assignment not found.' });
    }

    Assignment.subject_id=req.body.subject_id || Assignment.subject_id;
    Assignment.assignment_due_day=  req.body.assignment_due_day || Assignment.assignment_due_day ;
    Assignment.assignment_date=  req.body.assignment_date || Assignment.assignment_date;
    Assignment.assignments_due_date= req.body.assignments_due_date || Assignment.assignments_due_date;
    Assignment.title=  req.body.title || Assignment.title;
    await Assignment.save();

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
    const Assignment = await assignment.findByPk({id:req.query.assignment_id});
    if (!Assignment) {
      return res.status(404).json({ message: 'Assignment not found.' });
    }
    const AssignFiles= await assignment_file.findAll({
      where:{assignment_id: Assignment.assignment_id},
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
      await file.destroy();
    }

    res.status(200).json({ message: 'Assignment files deleted successfully.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error deleting assignment files.', error: error.message });
  }
};





