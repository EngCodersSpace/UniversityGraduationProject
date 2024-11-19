// routes/userRoute.js
const express = require('express');
const userController = require('../controllers/userController');
const router = express.Router();


router.get('/users', userController.getAllUsers);

router.get('/users/:id', userController.getUserById);

router.put('/users/:id', userController.updateUser);

router.delete('/users/:id', userController.deleteUser);



router.get('/doctor', userController.getAllDoctors);

router.get('/doctor/:id', userController.getDoctorById);

router.put('/doctor/:id', userController.updateDoctor);

router.delete('/doctor/:id', userController.deleteDoctor);



router.get('/student', userController.getAllStudents);

router.get('/student/:id', userController.getStudentById);

router.put('/student/:id', userController.updateStudent);

router.delete('/student/:id', userController.deleteStudent);







module.exports = router;

