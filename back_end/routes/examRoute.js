const express = require('express');
const router = express.Router();
const validate = require('../validations/examvalidation');
const CRUD = require('../controllers/examController');
const { verifyToken } = require('../middleware/authMiddleware');
const {checkPermission} = require('../middleware/roleMiddleware');

router.use(verifyToken);

router.post('/create-exam', checkPermission('exams', 'write'), validate.createExam, CRUD.createExam);
router.put('/update-exam',checkPermission('exams', 'write'), validate.updateExam, CRUD.updateExam );
router.delete('/delete-exam',checkPermission('exams', 'write'),  CRUD.deleteExam );

router.get('/get-all-exam',checkPermission('exams', 'accessOldTables'),  CRUD.getAllExams);
router.get('/get-exam', CRUD.getExam );
router.get('/get-exam-grouped', CRUD.getExamGroupedByCriteria );
router.get('/get-exam-grouped-Panle', CRUD.getExamGroupedByCriteriaPanel );
router.get('/get-exam-year', CRUD.getExamYear );

module.exports = router; 