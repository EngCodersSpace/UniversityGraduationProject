const express = require('express');
const router = express.Router();
const validate = require('../validations/examvalidation');
const CRUD = require('../controllers/examController');
const { verifyToken } = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');

router.use(verifyToken);

router.post('/create-exam',checkRole('student_affairs'), validate.createExam, CRUD.createExam);
router.put('/update-exam',checkRole(['student', 'dean']),validate.updateExam, CRUD.updateExam );
router.delete('/delete-exam',  CRUD.deleteExam );

router.get('/get-all-exam',  CRUD.getAllExams);
router.get('/get-exam', CRUD.getExam );
router.get('/get-exam-grouped', CRUD.getExamGroupedByCriteria );
router.get('/get-exam-year', CRUD.getExamYear );

module.exports = router; 