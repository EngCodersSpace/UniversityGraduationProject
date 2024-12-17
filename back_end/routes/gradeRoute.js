// gradeRoute.js
const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/gradeController');
const vali = require('../validations/gradevalidation');

router.post('/create-grade', vali.createGrade,   CRUD.createGrade);

router.get('/get-grades',   CRUD.getGrades);
router.get('/get-all-grades',   CRUD.getAllGrades);
router.get('/get-grade/:id',    CRUD.getGradeById);
router.get('/get-grade-year',    CRUD.getGradeYear);
router.get('/get-section',    CRUD.getSectionOfCurrentUser);





router.put('/update-grade/:id',vali.updateGrade, CRUD.updateGrade);
router.delete('/delete-grade/:id',     CRUD.deleteGrade);
 
module.exports = router;


 

