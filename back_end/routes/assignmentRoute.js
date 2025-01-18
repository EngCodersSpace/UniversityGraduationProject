const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/assignmentController');
const { verifyToken } = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');
router.use(verifyToken);

router.post('/upload-assignment-doctor', checkRole(['student_affairs', 'teacher','controller']), CRUD.createAssignment);
router.post('/upload-files-assignment-doctor', checkRole(['student_affairs', 'teacher','controller']), CRUD.uploadFilesForAssignment);
router.post('/upload-files-assignment-student', checkRole('student'), CRUD.uploadStudentFiles);

router.get('/get-student-assignments',checkRole(['teacher','controller']), CRUD.getStudentAssignments);
router.get('/get-assignments-subject',checkRole(['representative','student']), CRUD.getAssignmentsOfSubject);
router.get('/get-all-students-assignment',checkRole(['teacher','controller']), CRUD.getAllStudentsOfAssignment);
router.get('/get-students-assignment-files',checkRole(['teacher','controller']), CRUD.getStudentFiles);
router.get('/get-counts-assignment',checkRole(['representative','student']), CRUD.getCountAssignmentForSubject);

router.put('/update-assignment',checkRole(['teacher','controller']), CRUD.updateAssigment);
router.put('/update-student-assignment-status',checkRole(['teacher','controller']), CRUD.updateAssignmentStatus);
router.put('/update-student-assignment-complete',checkRole(['representative','student']), CRUD.updateStudentComplete);

router.delete('/delete-assignment',checkRole(['teacher','controller']), CRUD.deleteAssignment);
router.delete('/delete-assignment-files',checkRole(['teacher','controller']), CRUD.deleteAssigmentFiles);



module.exports = router;