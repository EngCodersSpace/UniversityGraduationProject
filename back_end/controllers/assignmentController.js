
const {student,assignment, assignment_file,student_assignment,student_assignment_file,user,section,level} = require("../models");
const { uploadFields } = require('../utils/multerConfig');
const path = require('path');
const fs = require("fs");
const fs = require('fs').promises;

const crypto = require('crypto');
const {  translateText } = require('../middleware/translationServices');
const { Worker, MessageChannel } = require('worker_threads');
const { ValidationError, UniqueConstraintError, ForeignKeyConstraintError } = require('sequelize');
const { upsertRefreshState} = require('../controllers/refreshController');

const { promisify } = require('util');
const statAsync = promisify(fs.stat);

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
            attributes: ['id', 'student_assignment_id', 'attachment', 'attachment_hash'],
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
    // Fetch file metadata from the database
    const fileData = await student_assignment_file.findByPk(req.query.id);
    if (!fileData) {
      return res.status(404).json({ message: "File not found in database." });
    }

    // Resolve the file path
    const filePath = path.resolve(__dirname, '..', `storage/${fileData.attachment}`);

    // Validate file existence and permissions
    await fs.access(filePath, fs.constants.R_OK);

    // Create a communication channel
    const statusChannel = new MessageChannel();

    // Initialize the worker
    const worker = new Worker(path.join(__dirname, "../utils/downloadWorker.js"), {
      workerData: { 
        filePath,
        range: req.headers.range, // Pass the range header to the worker
        port: statusChannel.port2 
      },
      transferList: [statusChannel.port2]
    });

    // Set response headers
    res.setHeader('Content-Type', 'application/json');
    res.write('{"status": "started", "message": "Download initiated"}');

    // Handle worker messages
    statusChannel.port1.on('message', (message) => {
      if (message.status === 'progress') {
        // Stream progress updates
        res.write(`,\n"progress": ${message.percentage}`);
      } else if (message.status === 'success') {
        // Finalize response
        res.end(`,\n"status": "completed", "path": "${message.filePath}"}]`);
      } else if (message.status === 'error') {
        // Handle worker errors
        if (!res.headersSent) {
          res.status(500).json({ 
            status: "error",
            message: "Download failed",
            error: message.error 
          });
        }
      }
    });

    // Handle worker errors
    worker.on('error', (err) => {
      if (!res.headersSent) {
        res.status(500).json({ 
          status: "error",
          message: "Download failed",
          error: err.message 
        });
      }
    });

    // Handle worker exit
    worker.on('exit', (code) => {
      if (code !== 0 && !res.headersSent) {
        res.status(500).json({
          status: "error",
          message: `Worker stopped with exit code ${code}`
        });
      }
    });

  } catch (error) {
    if (!res.headersSent) {
      res.status(500).json({ 
        status: "error",
        message: "Download failed",
        error: error.message 
      });
    }
  }
};





exports.downloadFile3 = async (req, res) => {
  try {
    const fileData = await student_assignment_file.findByPk(req.query.id);
    if (!fileData) {
      return res.status(404).json({ message: "File not found in database." });
    }
    const filePath= path.resolve(__dirname,'..',`storage/${fileData.attachment}`);
    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ message: "File not found on server." });
    }

    const worker = new Worker(path.join(__dirname, "../utils/downloadWorker.js"), {
      workerData: { filePath },
    });
    console.log(`\n \n worker find path ${filePath} \n \n` );
    worker.on("message", (message) => {
      if (message.status === "success") {
        console.log(`\n \n \nDownload started in the background.${message.status} \n ${message.filePath}\n \n` );
        // res.status(200).json({ message: "Download started in the background.", path: message.filePath });
      }
    });
    worker.on("error", (err) => {
      console.log(`\n \n \n Error occurred during the download process.${err.message} \n \n \n `);
      // res.status(500).json({ message: "Error occurred during the download process.", error: err.message });
    });
    
    res.status(200).json({ message: "Download Finish " });
  } catch (error) {
    console.error("Error during download:", error);
    res.status(500).json({ message: "Failed to start download.", error: error.message });
  }
};

exports.downloadFile1 = async (req, res) => {
  try {
    const fileData = await student_assignment_file.findByPk(req.query.id);
    if (!fileData) {
      return res.status(404).json({ message: "File not found in database." });
    }

    const filePath= path.resolve(__dirname,'..',`storage/${fileData.attachment}`);
    const stat = fs.statSync(filePath);
    const range = req.headers.range;

    if (range) {
      const parts = range.replace(/bytes=/, '').split('-');
      const start = parseInt(parts[0], 10);
      const end = parts[1] ? parseInt(parts[1], 10) : stat.size - 1;
      const chunkSize = (end - start) + 1;

      res.writeHead(206, {
        'Content-Range': `bytes ${start}-${end}/${stat.size}`,
        'Accept-Ranges': 'bytes',
        'Content-Length': chunkSize,
        'Content-Type': 'application/octet-stream',
      });

      const stream = fs.createReadStream(filePath, { start, end });
      stream.pipe(res);
    } else {
      res.writeHead(200, {
        'Content-Length': stat.size,
        'Content-Type': 'application/octet-stream',
      });
      fs.createReadStream(filePath).pipe(res);
    }

  } catch (error) {
    console.error("Error during download:", error);
    res.status(500).json({ message: "Failed to start download.", error: error.message });
  }
};

exports.downloadFile2 = async (req, res) => {
    try {
      const fileData = await student_assignment_file.findByPk(req.query.id);
      if (!fileData) {
        return res.status(404).json({ message: "File not found in database." });
      }
  
      const filePath= path.resolve(__dirname,'..',`storage/${fileData.attachment}`);
      const stats = await fs.promises.stat(filePath);

      res.setHeader('Content-Disposition', 'attachment; filename="file.zip"');
      res.setHeader('Content-Type', 'application/zip');
      res.setHeader('Content-Length', stats.size);

      const stream = fs.createReadStream(filePath);
      stream.pipe(res);
      
      stream.on('error', (err) => {
        if (!res.headersSent) res.status(500).send('Error streaming file');
      });
    } catch (err) {
      res.status(500).json({ message: "Failed to start download.", error: err.message });
    }
};

exports.downloadFile4 = async (req, res) => {
  try {
    const fileData = await student_assignment_file.findByPk(req.query.id);
    if (!fileData) {
      return res.status(404).json({ message: "File not found in database." });
    }

    const filePath = path.resolve(__dirname, '..', `storage/${fileData.attachment}`);
    const stat = await statAsync(filePath); 

    const range = req.headers.range;
    if (range) {
      const parts = range.replace(/bytes=/, '').split('-');
      const start = parseInt(parts[0], 10);
      const end = parts[1] ? parseInt(parts[1], 10) : stat.size - 1;
      
      if (start >= stat.size || end >= stat.size) {
        return res.status(416).header('Content-Range', `bytes */${stat.size}`).send();
      }

      const chunkSize = end - start + 1;
      
      res.writeHead(206, {
        'Content-Range': `bytes ${start}-${end}/${stat.size}`,
        'Accept-Ranges': 'bytes',
        'Content-Length': chunkSize,
      });

      const stream = fs.createReadStream(filePath, { start, end });
      
      stream.on('error', (err) => {
        if (!res.headersSent) {
          res.status(500).json({ message: "Stream error", error: err.message });
        }
      });
      
      stream.pipe(res);
    } else {
      res.writeHead(200, {
        'Content-Length': stat.size,
        'Content-Disposition': `attachment; filename="${path.basename(filePath)}"`
      });

      const stream = fs.createReadStream(filePath);
      
      stream.on('error', (err) => {
        if (!res.headersSent) {
          res.status(500).json({ message: "Stream error", error: err.message });
        }
      });
      
      stream.pipe(res);
    }

  } catch (error) {
    if (!res.headersSent) {
      res.status(500).json({ message: "Download failed", error: error.message });
    }
    console.error("Download error:", error);
  }
};

// download files of assignment-file
exports.doctorDownloadFile = async (req, res) => {
  try {
    const fileData = await assignment_file.findByPk(req.query.id);
    if (!fileData) {
      return res.status(404).json({ message: "File not found in database." });
    }
    const filePath= path.resolve(__dirname,'..',`storage/${fileData.attachment}`);
    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ message: "File not found on server." });
    }

    const worker = new Worker(path.join(__dirname, "../utils/downloadWorker.js"), {
      workerData: { filePath },
    });
    console.log(`\n \n worker find path ${filePath} \n \n` );
    worker.on("message", (message) => {
      if (message.status === "success") {
        console.log(`\n \n \nDownload started in the background.${message.status} \n ${message.filePath}\n \n` );
        // res.status(200).json({ message: "Download started in the background.", path: message.filePath });
      }
    });
    worker.on("error", (err) => {
      console.log(`\n \n \n Error occurred during the download process.${err.message} \n \n \n `);
      // res.status(500).json({ message: "Error occurred during the download process.", error: err.message });
    });
    
    res.status(200).json({ message: "Download started in the background." });
  } catch (error) {
    console.error("Error during download:", error);
    res.status(500).json({ message: "Failed to start download.", error: error.message });
  }
};

exports.doctorDownloadFile1 = async (req, res) => {
  try {
    const fileData = await assignment_file.findByPk(req.query.id);
    if (!fileData) {
      return res.status(404).json({ message: "File not found in database." });
    }
    const filePath= path.resolve(__dirname,'..',`storage/${fileData.attachment}`);
    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ message: "File not found on server." });
    }

    // Stream the file directly
    res.download(filePath, (err) => {
      if (err) {
        if (!res.headersSent) {
          res.status(500).json({ message: "Download failed", error: err.message });
        }
      }
    });
    
  } catch (error) {
    console.error("Error during download:", error);
    res.status(500).json({ message: "Failed to start download.", error: error.message });
  }
};

exports.doctorDownloadFile2 = async (req, res) => {
  try {
    const fileData = await assignment_file.findByPk(req.query.id);
    if (!fileData) {
      return res.status(404).json({ message: "File not found in database." });
    }
    const filePath= path.resolve(__dirname,'..',`storage/${fileData.attachment}`);
    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ message: "File not found on server." });
    }

    const stats = await fs.promises.stat(filePath);

      res.setHeader('Content-Disposition', 'attachment; filename="file.zip"');
      res.setHeader('Content-Type', 'application/zip');
      res.setHeader('Content-Length', stats.size);

      const stream = fs.createReadStream(filePath);
      stream.pipe(res);
      
      stream.on('error', (err) => {
        if (!res.headersSent) res.status(500).send('Error streaming file');
      });
    } catch (err) {
      res.status(500).json({ message: "Failed to start download.", error: err.message });
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
    const sectionName = await section.findOne({ where: { id: req.query.section_id } });
    const levelName = await level.findOne({ where: { id: req.query.level_id } });

    if (!sectionName || !levelName) {
      throw new Error("Section or Level not found with the provided IDs.");
    }

    const sectionNameObj = JSON.parse(sectionName.section_name); 
    const sectionName1 = sectionNameObj.en; 
    const request=`${sectionName1}/${levelName.level_name}`;
    
    uploadFields('assignments/attachment-files', request ).single('file')(req, res, async (err) => {
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

        await upsertRefreshState("assignment",`section_id : ${req.query.section_id} - level_id : ${req.query.level_id}`);

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

    await upsertRefreshState("assignment",`section_id : ${req.body.section_id} - level_id : ${req.body.level_id}`);
    
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
    const sectionName = await section.findOne({ where: { id: req.query.section_id } });
    const levelName = await level.findOne({ where: { id: req.query.level_id } });

    if (!sectionName || !levelName) {
      throw new Error("Section or Level not found with the provided IDs.");
    }

    const sectionNameObj = JSON.parse(sectionName.section_name); 
    const sectionName1 = sectionNameObj.en; 
    const request=`${sectionName1}/${levelName.level_name}`;

    uploadFields('assignments/students-attachment-files', request ).single('file')(req, res, async (err) => {
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

    await upsertRefreshState("assignment",`section_id : ${Assignment.section_id} - level_id : ${Assignment.level_id}`);
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

    await upsertRefreshState("assignment",`section_id : ${Assignment.section_id} - level_id : ${Assignment.level_id}`);
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
      where:{assignment_id: req.query.assignment_id},
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
      where:{student_assignment_id: req.query.id},
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