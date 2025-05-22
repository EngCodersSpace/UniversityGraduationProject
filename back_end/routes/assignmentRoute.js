const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/assignmentController');
const {checkPermission , checkStudentsAccess , checkDoctorAccess,checkUserAccess} = require('../middleware/roleMiddleware');

const { verifyToken } = require('../middleware/authMiddleware');
router.use(verifyToken);

router.post('/upload-assignment-doctor',checkPermission('assignments', 'write'), CRUD.createAssignment);
router.post('/check-files',  CRUD.getFileDetails); // frontend use it (not user)
router.post('/upload-files-assignment-doctor',checkDoctorAccess, CRUD.uploadFileForAssignment);
router.post('/upload-files-assignment-student',checkStudentsAccess, CRUD.uploadFilesAttachment);

router.get('/get-assignments-subject',checkUserAccess,CRUD.getAssignmentsOfSubject); //Both Doctors and Students  see below i'm split it 
router.get('/get-assignments-subject-student', checkStudentsAccess, CRUD.getAssignmentsForStudent);//1- for students
router.get('/get-assignments-subject-doctor', checkDoctorAccess, CRUD.getAssignmentsForDoctor);//2- for doctors
router.get('/get-all-assignment-panel',checkDoctorAccess, CRUD.getAssignmentsPanel);
router.get('/get-year-assignment',checkDoctorAccess, CRUD.getAssignmentYear);


router.get('/get-all-students-assignment',checkDoctorAccess, CRUD.getStudentsAndFilesByAssignment);
router.get('/download-assignment-files',checkDoctorAccess, CRUD.downloadFile);  // doctors download what students upload for specific assignment
router.get('/download-files-doctor',checkStudentsAccess, CRUD.doctorDownloadFile);// students download what doctor upload for specific assignment

router.put('/update-assignment',checkPermission('assignments', 'write'), CRUD.updateAssigment);
router.put('/update-student-assignment-status',checkPermission('assignments', 'setStatus'), CRUD.updateAssignmentStatus);
router.put('/update-student-assignment-complete',checkPermission('assignments', 'setCompletion'), CRUD.updateStudentComplete);

router.delete('/delete-assignment',checkPermission('assignments', 'write'), CRUD.deleteAssignment);
router.delete('/delete-assignment-files',checkPermission('assignments', 'write'), CRUD.deleteAssigmentFiles);
router.delete('/delete-attachment-files',checkPermission('assignments', 'write'), CRUD.deleteAttachmentFiles);

module.exports = router;