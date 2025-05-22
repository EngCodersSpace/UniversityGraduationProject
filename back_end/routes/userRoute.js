// routes/userRoute.js
const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/userController');
const {checkPermission} = require('../middleware/roleMiddleware');
const { verifyToken } = require('../middleware/authMiddleware');
router.use(verifyToken);

router.get('/users', CRUD.getAllUsers);
router.get('/users/:id', CRUD.getUserById);
router.delete('/users/:id',checkPermission('users', 'write'), CRUD.deleteUser);


router.get('/doctor', CRUD.getAllDoctors);
router.get('/doctor/:id', CRUD.getDoctorById);
router.get('/get-doctors-panle', CRUD.getDoctorsByCriteriaPanel);
router.put('/doctor/:id',checkPermission('doctors', 'write'), CRUD.updateDoctor);
router.delete('/doctor/:id',checkPermission('doctors', 'write'), CRUD.deleteDoctor);


router.get('/student', CRUD.getAllStudents);
router.get('/student/:id', CRUD.getStudentById);
router.get('/get-student-panle', CRUD.getStudentsByCriteriaPanel);
router.put('/student/:id',checkPermission('students', 'write'), CRUD.updateStudent);
router.delete('/student/:id',checkPermission('students', 'write'), CRUD.deleteStudent);


module.exports = router;
