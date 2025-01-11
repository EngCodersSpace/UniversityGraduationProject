const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/assignmentController');
const { verifyToken } = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');
router.use(verifyToken);

// router.post('/create-assignment', checkRole(['student_affairs', 'teacher','controller']),CRUD.);
router.get('/get-assignment-student',checkRole(['student_affairs', 'teacher','controller','student']), CRUD.getAssignmentsBySubject);
// router.delete('/delete-assignment', checkRole(['student_affairs', 'teacher','controller']), CRUD.);

module.exports = router;