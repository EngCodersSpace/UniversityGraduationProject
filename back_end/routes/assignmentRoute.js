const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/assignmentController');
const { verifyToken } = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');
router.use(verifyToken);

router.post('/upload-assignment-doctor', CRUD.createAssignment);
router.post('/check-files', CRUD.getFileDetails);
router.post('/upload-files-assignment-doctor',CRUD.uploadFileForAssignment);
router.post('/upload-files-assignment-student', CRUD.uploadFilesAttachment);



router.get('/get-assignments-subject',CRUD.getAssignmentsOfSubject);
router.get('/get-all-students-assignment', CRUD.getStudentsAndFilesByAssignment);
router.get('/download-assignment', CRUD.downloadFile);

// router.get('/get-students-assignment-files',checkRole(['lecturer','controller','representative']), CRUD.getStudentFiles);

router.put('/update-assignment',checkRole(['lecturer','controller']), CRUD.updateAssigment);
router.put('/update-student-assignment-status',checkRole(['lecturer','controller']), CRUD.updateAssignmentStatus);
router.put('/update-student-assignment-complete',checkRole(['representative','student']), CRUD.updateStudentComplete);

router.delete('/delete-assignment',checkRole(['controller','lecturer']), CRUD.deleteAssignment);
router.delete('/delete-assignment-files',checkRole(['controller','lecturer']), CRUD.deleteAssigmentFiles);



module.exports = router;