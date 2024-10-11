// gradeRoute.js
const express = require('express');
const router = express.Router();
const gradeController = require('../controllers/gradeController');
const auth = require('../middleware/authMiddleware');
const authorize = require('../middleware/authorizeMiddleware');
const validateGrade = require('../middleware/validateGradeMiddleware');


router.post('/grades', auth, authorize(['admin', 'teacher']), gradeController.createGrade);
router.delete('/grades/:id', auth, authorize(['admin']), gradeController.deleteGrade);
router.post('/grades', auth, validateGrade, gradeController.createGrade);

module.exports = router;
