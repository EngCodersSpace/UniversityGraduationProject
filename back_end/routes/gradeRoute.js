// gradeRoute.js
const express = require('express');
const router = express.Router();
const gC = require('../controllers/gradeController');
const vali = require('../validations/gradevalidation');

router.post('/create-grade', vali.createGrade,   gC.createGrade);
router.get('/get-all-grades',   gC.getAllGrades);
router.get('/get-grade/:id',    gC.getGradeById);
router.put('/update-grade/:id',vali.updateGrade, gC.updateGrade);
router.delete('/delete-grade/:id',     gC.deleteGrade);

module.exports = router;




