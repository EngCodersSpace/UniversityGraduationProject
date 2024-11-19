// doctorRoute.js
// const express = require('express');
// const router = express.Router();
// const doctorController = require('../controllers/doctorController');
// const authToken = require('../middleware/authMiddleware');
// const checkRole = require('../middleware/roleMiddleware');

// // Apply authentication middleware for all routes
// router.use(authToken.verifyToken);

// // CRUD routes
// router.get('/doctors',checkRole('teacher'), doctorController.getAllDoctors); 
// router.get('/doctors/:id', checkRole('admin', 'teacher'), doctorController.getDoctorById); 
// router.post('/doctors', checkRole('admin'), doctorController.createDoctor); 
// router.put('/doctors/:id', checkRole('admin'), doctorController.updateDoctor); 
// router.delete('/doctors/:id', checkRole('admin'), doctorController.deleteDoctor); 

// module.exports = router;








