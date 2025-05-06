
const {student,assignment, assignment_file,student_assignment,student_assignment_file,user,section,level} = require("../models");
const { uploadFields } = require('../utils/multerConfig');
const path = require('path');
const fs = require('fs');
const crypto = require('crypto');
const {  translateText } = require('../middleware/translationServices');
const { ValidationError, UniqueConstraintError, ForeignKeyConstraintError } = require('sequelize');
const { upsertRefreshState} = require('../controllers/refreshController');

// get assignments for specific subject of doctor  => 
// query (  level_id  section_id  and  subject_id)
exports.getAssignmentsOfSubject = async (req, res) => {
  try {
    
    if (req.user.permission == 'Student' || req.user.permission =='Student Representative'){
      const AllAssignmentSub = await assignment.findAll({
        where: {
          subject_id: req.query.subject_id,
          level_id: req.query.level_id,
          section_id: req.query.section_id,
        },
        include: [
          {
            model:assignment_file,
          },
          {
            model:student_assignment , where:{student_id:req.user.user_id},

            include:[
              {
                model:student_assignment_file,
              },
              {
                model:student.scope(null),as:'student',
                attributes:['student_id'],
                include:[
                  {
                    model:user,as:'user',
                    attributes:['user_name'],
                  }
                ],
              }
            ],
          },
        ],
      });

      if (!AllAssignmentSub) {
        return res.status(404).json({
          message: "No assignment found ",
        });
      }

      if (AllAssignmentSub.length === 0) {
        return res.status(204).send(); 
      }

      res.status(200).json({
        message: 'Assignments retrieved successfully for student.',
        data: AllAssignmentSub,
      });
    } else if (req.user.permission === 'Dean' || req.user.permission ==='Controller' || req.user.permission ==='Instructor') {
      const AllAssignmentSub = await assignment.findAll({
        where: {
          subject_id: req.query.subject_id,
          level_id: req.query.level_id,
          section_id: req.query.section_id,
        },
        include:[
          {model:assignment_file},
        ],
      });

      if (!AllAssignmentSub) {
        return res.status(404).json({
          message: "No assignment found ",
        });
      }

      if (AllAssignmentSub.length === 0) {
        return res.status(204).send(); 
      }

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

// to see students of this assignment and their files
exports.getStudentsAndFilesByAssignment = async (req, res) => {
  try {
    const fileDetail=await student_assignment.findAll({
      where:{assignment_id:req.query.assignment_id},
       include: [
          {
            model: student_assignment_file, 
          },
          {
            model:student.scope(null),as:'student',
            attributes:['student_id'],
            include:[
              {
                model:user,as:'user',
                attributes:['user_name'],
              }
            ],
          }
        ],
    });

    if (!fileDetail) {
      return res.status(404).json({
        message: "No assignment found with the provided ID.",
      });
    }
    if (fileDetail.length === 0) {
      return res.status(204).send(); 
    }

    res.status(200).json({
      message: "Students and files retrieved successfully.",
      data:fileDetail,
    });
  } catch (error) {
    console.error("Error fetching data:", error);
    res.status(500).json({
      message: "Error fetching students and files.",
      error: error.message,
    });
  }
};

// download files of student_assignment-file
exports.downloadFile = async (req, res) => {
  try {
    const fileData = await student_assignment_file.findByPk(req.query.id);
    if (!fileData) return res.status(404).json({ error: "File not found" });

    const filePath = path.resolve(__dirname, '..', `storage/${fileData.attachment}`);
    const fileSize = fs.statSync(filePath).size;

    // Set headers to instruct the browser to download the file
    res.setHeader('Content-Disposition', `attachment; filename="${path.basename(filePath)}"`);
    res.setHeader('Content-Type', 'application/octet-stream');
    res.setHeader('Content-Length', fileSize);

    // Create a read stream and pipe it directly to the response
    const readStream = fs.createReadStream(filePath);
    readStream.pipe(res);

    readStream.on('error', (err) => {
      console.error("Error during streaming:", err);
      res.status(500).end('Error reading file.');
    });

  } catch (error) {
    console.error("Error during download:", error);
    res.status(500).json({ 
      error: "Download failed",
      details: error.message 
    });
  }
};

// download files of assignment-file
exports.doctorDownloadFile = async (req, res) => {
  try {
    const fileData = await assignment_file.findByPk(req.query.id);
    if (!fileData) return res.status(404).json({ error: "File not found" });

    const filePath = path.resolve(__dirname, '..', `storage/${fileData.attachment}`);
    const fileSize = fs.statSync(filePath).size;

    // Set headers to instruct the browser to download the file
    res.setHeader('Content-Disposition', `attachment; filename="${path.basename(filePath)}"`);
    res.setHeader('Content-Type', 'application/octet-stream');
    res.setHeader('Content-Length', fileSize);

    // Create a read stream and pipe it directly to the response
    const readStream = fs.createReadStream(filePath);
    readStream.pipe(res);

    readStream.on('error', (err) => {
      console.error("Error during streaming:", err);
      res.status(500).end('Error reading file.');
    });

  } catch (error) {
    console.error("Error during download:", error);
    res.status(500).json({ 
      error: "Download failed",
      details: error.message 
    });
  }
};

// to checks if file duplicate or not
exports.getFileDetails = async (req, res) => {
  try {
      const hash= crypto.createHash('md5').update(req.body.originalname + req.body.size).digest('hex');

      const existingFile = await assignment_file.findOne({
        where:{attachment_hash: hash},
        include:[
          {
            model: assignment,
            where: {section_id:req.body.section_id , level_id:req.body.level_id}, 
          }
        ],
      });

      if (existingFile) {
        return res.status(400).json({message: 'Sorry , This File is already uploaded.'});
      } else {
        return res.status(200).json({message: 'File ready to uploaded successfully.'});
      }
  } catch (error) {
    console.error('Error while checking file duplicates:', error.message);
    res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};

exports.uploadFileForAssignment = async (req, res) => {
  try {
    uploadFields('assignments', 'attachment-files' ).single('file')(req, res, async (err) => {
      if (err) {
        return res.status(400).json({ message: 'Error during file upload.', error: err.message });
      }

      if (!req.file) {
        return res.status(400).json({ message: 'No file provided for upload.' });
      }

      try {
        const newFile = await assignment_file.create({
          assignment_id: req.query.assignment_id,
          attachment: req.file.path,
          attachment_hash: req.file.hash,
          original_name:req.file.originalName
        });

        // await upsertRefreshState("assignment", {
        //   section_id: sectionName, 
        //   level_id:  levelName     
        // });

        res.status(201).json({
          message: 'File uploaded successfully.',
          file: {
            id: newFile.id,
            path: newFile.attachment,
            hash: newFile.attachment_hash,
          },
        });
      } catch(error){
        res.status(500).json({ message: 'Internal server Error.', error: error.message });
      }
    });     
  } catch (error) {
    console.error('Error while uploading file:', error.message);
    res.status(500).json({ message: 'Internal server error.', error: error.message });
  }
};

exports.createAssignment = async (req, res) => {
  try {
    const sectionsAndLevels = req.body.sectionsAndLevels;

    if (!sectionsAndLevels || sectionsAndLevels.length === 0) {
      return res.status(400).json({ message: 'No sections and levels provided.' });
    }

    const createdAssignments = [];

    const targetLanguage = req.headers['accept-language'] === 'en' ? 'ar' : 'en';
    const translatedTitle = await translateText(req.body.title, req.headers['accept-language'], targetLanguage);

    for (const { section_id, level_id } of sectionsAndLevels) {
      const assignmentRecord = await assignment.create({
        subject_id: req.body.subject_id,
        doctor_id: req.user.user_id,
        title: JSON.stringify({
          [req.headers['accept-language']]: req.body.title,
          [targetLanguage]: translatedTitle,
        }),
        assignment_due_day: req.body.assignment_due_day,
        assignment_date: req.body.assignment_date,
        assignments_due_date: req.body.assignments_due_date,
        original_name:req.body.original_name,
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


    // Refresh state for each section-level combination
    if (req.body.sectionsAndLevels && Array.isArray(req.body.sectionsAndLevels)) {
      await Promise.all(
          req.body.sectionsAndLevels.map(async (item) => {
              await upsertRefreshState("assignment", {
                  section_id: item.section_id ?? null,
                  level_id: item.level_id ?? null
              });
          })
      );
    }


    res.status(201).json({
      message: 'Assignments created successfully for the specified sections and levels.',
      data: createdAssignments,
    });
  } catch (error) {
    console.error(error);

    if (error instanceof UniqueConstraintError) {
      return res.status(400).json({ message: 'Duplicate entry error: ' + error.message });
    }

    if (error instanceof ForeignKeyConstraintError) {
      return res.status(400).json({ message: 'Foreign key violation: ' + error.message });
    }

    if (error instanceof ValidationError) {
      return res.status(400).json({ message: 'Validation error: ' + error.message });
    }

    res.status(500).json({
      message: 'Error creating assignment.',
      error: error.message,
    });
  }
};

// when student upload files of specific assignment attachement
exports.uploadFilesAttachment = async (req, res) => {
  try {
    
    uploadFields('assignments','students-attachment-files').single('file')(req, res, async (err) => {
      if (err) {
        return res.status(400).json({ message: 'Error during file upload.', error: err.message });
      }

      try {
        if (!req.file) {
          return res.status(400).json({ message: 'No file provided for upload.' });
        }
        const studentAssignment = await student_assignment.findOne({
          where: {
            student_id: req.user.user_id,
            assignment_id: req.query.assignment_id,
          },
        });

        const newFile = await student_assignment_file.create({
          student_assignment_id: studentAssignment.id,
          attachment: req.file.path,
          attachment_hash: req.file.hash,
          original_name:req.file.originalName
        });

        res.status(201).json({
          message: 'File uploaded successfully.',
          file: {
            id: newFile.id,
            student_assignment_id:newFile.student_assignment_id,
            path: newFile.attachment,
            hash: newFile.attachment_hash,
          },
        });
      }catch(error){
        console.error('Error while uploading file:', error.message);
      }
    });
  } catch (error) {
    console.error('Error while uploading file:', error.message);
    res.status(500).json({ message: 'Internal server error.', error: error.message });
  }
};

// Doctor updates the status of a student's assignment (4)
exports.updateAssignmentStatus = async (req, res) => {
  try {
    const studentAssignment = await student_assignment.findOne({
      where: { id: req.query.id, student_id : req.query.student_id },
    });

    if (!studentAssignment) {
      return res.status(404).json({ message: 'Student assignment not found.' });
    }

    studentAssignment.status = req.query.status;
    await studentAssignment.save();

    res.status(200).json({
      message: `Assignment status updated to "${req.query.status}" successfully.`,
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
      where: { id: req.query.id , student_id : req.query.student_id },
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
      where:{id:req.query.assignment_id},
    });

    if (!Assignment) {
      return res.status(404).json({ message: 'Assignment not found.' });
    }

    const targetLanguage = req.headers['accept-language'] === 'en' ? 'ar' : 'en';
    const translatedTitle = await translateText(req.body.title, req.headers['accept-language'], targetLanguage);

    const updatedFields = {
      subject_id: req.body.subject_id || Assignment.subject_id,
      assignment_due_day: req.body.assignment_due_day || Assignment.assignment_due_day,
      assignment_date: req.body.assignment_date || Assignment.assignment_date,
      assignments_due_date: req.body.assignments_due_date || Assignment.assignments_due_date,
      title:JSON.stringify({[req.headers['accept-language']] : req.body.title, [targetLanguage] : translatedTitle }) || Assignment.title,
      original_name:req.body.original_name || Assignment.original_name,
      section_id: req.body.section_id || Assignment.section_id,
      level_id: req.body.level_id || Assignment.level_id,
    };

    await upsertRefreshState("assignment", {
      section_id: Assignment.section_id , 
      level_id:  Assignment.level_id     
    });
    
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

    // await assignment_file.destroy({where:{assignment_id: Assignment.id}});
    await upsertRefreshState("assignment", {
      section_id: Assignment.section_id , 
      level_id:  Assignment.level_id     
    });
    await Assignment.destroy();

    res.status(200).json({ message: 'Assignment deleted successfully.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error deleting assignment.', error: error.message });
  }
};

// doctor  only deletes file's assignment 
exports.deleteAssigmentFiles=async(req,res)=>{
  try {
    const AssignFiles= await assignment_file.findAll({
      where:{id: req.query.id},
    });

    for (const file of AssignFiles) {
      const attachmentPath = path.resolve('storage',file.attachment);
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

exports.deleteAttachmentFiles=async(req,res)=>{
  try {
    const AssignFiles= await student_assignment_file.findAll({
      where:{id: req.query.id},
    });
 
    for (const file of AssignFiles) {
      const attachmentPath = path.resolve('storage',file.attachment);
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