// routes/userRoute.js
const express = require('express');
const CRUD = require('../controllers/userController');

const authToken = require('../middleware/authMiddleware');
// const {checkRole} = require('../middleware/roleMiddleware');

const router = express.Router();
router.use(authToken.verifyToken);



router.get('/users', CRUD.getAllUsers);
router.get('/users/:id', CRUD.getUserById);
router.delete('/users/:id', CRUD.deleteUser);



router.get('/doctor', CRUD.getAllDoctors);
router.get('/doctor/:id', CRUD.getDoctorById);
router.get('/get-doctors-panle', CRUD.getDoctorsByCriteriaPanel);

router.put('/doctor/:id', CRUD.updateDoctor);
router.delete('/doctor/:id', CRUD.deleteDoctor);



router.get('/student', CRUD.getAllStudents);
router.get('/student/:id', CRUD.getStudentById);
router.get('/get-student-panle', CRUD.getStudentsByCriteriaPanel);

router.put('/student/:id', CRUD.updateStudent);
router.delete('/student/:id', CRUD.deleteStudent);



module.exports = router;