// routes/authRoute.js
const express = require('express');
const router = express.Router();
const vali = require('../validations/authvalidation');
const authController = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');


router.post('/login', authController.login);

router.post('/login/authToken', authMiddleware.verifyToken);

router.get('/me', authMiddleware.verifyToken, authController.getCurrentUser);

router.post('/refresh', authController.refreshToken);

router.post('/registerDoctor',authController.registerDoctor);

router.post('/registerStudent',authController.registerStudent);

router.post('/request-password-reset', vali.validateRequestPasswordReset , authController.requestPasswordReset);

router.get('/verify-reset-token',authController.verifyResetToken);

router.post('/reset-password', vali.validateResetPassword , authController.resetPassword);



module.exports = router;






// const checkRole = require('./middleware/role');
// router.get('/admin-only', checkRole(['admin']), adminController.getAdminData);
// router.get('/doctor-data', checkRole(['doctor']), doctorController.getDoctorData);

