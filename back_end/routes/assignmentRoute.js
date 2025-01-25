const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/assignmentController');
const { verifyToken } = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');
router.use(verifyToken);

router.post('/upload-assignment-doctor', checkRole(['student_affairs','controller','lecturer']), CRUD.createAssignment);
router.post('/upload-files-assignment-doctor', checkRole(['student_affairs','controller','lecturer']),CRUD.uploadFilesForAssignment);
router.post('/upload-files-assignment-student', checkRole(['student','representative']), CRUD.uploadFilesAttachment);

router.post('/check-files', CRUD.getFileDetails);


router.get('/get-assignments-subject',checkRole(['representative','student','lecturer']), CRUD.getAssignmentsOfSubject);
router.get('/get-all-students-assignment',checkRole(['lecturer','controller','lecturer']), CRUD.getStudentsAndFilesByAssignment);
router.get('/get-students-assignment-files',checkRole(['lecturer','controller','representative']), CRUD.getStudentFiles);

router.put('/update-assignment',checkRole(['lecturer','controller']), CRUD.updateAssigment);
router.put('/update-student-assignment-status',checkRole(['lecturer','controller']), CRUD.updateAssignmentStatus);
router.put('/update-student-assignment-complete',checkRole(['representative','student']), CRUD.updateStudentComplete);

router.delete('/delete-assignment',checkRole(['controller','lecturer']), CRUD.deleteAssignment);
router.delete('/delete-assignment-files',checkRole(['controller','lecturer']), CRUD.deleteAssigmentFiles);



module.exports = router;