// gradeRoute.js
const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/gradeController');
const vali = require('../validations/gradevalidation');
const { verifyToken  } = require('../middleware/authMiddleware');
const {checkPermission,checkStudentAccess,checkDoctorAccess} = require('../middleware/roleMiddleware');

router.use(verifyToken);
router.post('/create-grade',checkPermission('grades', 'write'), vali.createGrade,   CRUD.createGrade);
router.get('/get-grades',  checkStudentAccess,  CRUD.getGrades);
router.get('/get-all-grades', checkDoctorAccess, checkPermission('grades', 'student_search'),  CRUD.getAllGrades);
router.get('/get-grade/:id',  checkDoctorAccess,   CRUD.getGradeById);
router.get('/get-grade-year',  checkDoctorAccess,   CRUD.getGradeYear);
router.get('/get-doctor-grades',checkDoctorAccess,   CRUD.getDoctorGrades);
router.get('/get-grades-grouped-panle',checkDoctorAccess,    CRUD.getGradesByCriteriaPanel);
router.get('/get-section',    CRUD.getSectionOfCurrentUser);
router.put('/update-grade/:id',checkPermission('grades', 'write'),vali.updateGrade, CRUD.updateGrade);
router.delete('/delete-grade/:id',checkPermission('grades', 'write'),  CRUD.deleteGrade);
 
module.exports = router;