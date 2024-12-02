const express = require('express');
const router = express.Router();
const validate = require('../validations/examvalidation');
const examController = require('../controllers/examController');
// const authMiddleware = require('../middleware/authMiddleware');

router.post('/create-exam', validate.createExam, examController.createExam);
router.get('/get-all-exam',  examController.getAllExams);
router.get('/get-exam/:id', examController.getExam );
router.put('/update/:id',validate.updateExam, examController.updateExam );
router.delete('/delete/:id',  examController.deleteExam );

module.exports = router; 
