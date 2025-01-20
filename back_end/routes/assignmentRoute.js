const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/assignmentController');
const { verifyToken } = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');
router.use(verifyToken);

router.post('/upload-assignment-doctor', checkRole(['student_affairs', 'teacher','controller','lecturer']), CRUD.createAssignment);
router.post('/upload-files-assignment-doctor', checkRole(['student_affairs', 'teacher','controller','lecturer']), CRUD.uploadFilesForAssignment);
router.post('/upload-files-assignment-student', checkRole(['student','representative']), CRUD.uploadFilesAttachment);

router.get('/get-student-assignments',checkRole(['teacher','controller','representative','student']), CRUD.getStudentAssignments);
router.get('/get-assignments-subject',checkRole(['representative','student']), CRUD.getAssignmentsOfSubject);
router.get('/get-all-students-assignment',checkRole(['teacher','controller']), CRUD.getAllStudentsOfAssignment);
router.get('/get-students-assignment-files',checkRole(['teacher','controller','representative']), CRUD.getStudentFiles);

router.put('/update-assignment',checkRole(['teacher','controller','lecturer']), CRUD.updateAssigment);
router.put('/update-student-assignment-status',checkRole(['teacher','controller']), CRUD.updateAssignmentStatus);
router.put('/update-student-assignment-complete',checkRole(['representative','student']), CRUD.updateStudentComplete);

router.delete('/delete-assignment',checkRole(['teacher','controller','lecturer']), CRUD.deleteAssignment);
router.delete('/delete-assignment-files',checkRole(['teacher','controller','lecturer']), CRUD.deleteAssigmentFiles);



module.exports = router;