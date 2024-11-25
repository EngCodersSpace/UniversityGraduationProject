// routes/authRoute.js
const express = require('express');
const router = express.Router();
const vali = require('../validations/authvalidation');
const authController = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');


// Route for user login
router.post('/login', authController.login);

// Route for token verification
router.post('/login/authToken', authMiddleware.verifyToken);

// إضافة المسار لعرض بيانات المستخدم المسجل دخوله حالياً
router.get('/me', authMiddleware.verifyToken, authController.getCurrentUser);

//To refresh Token
router.post('/refresh', authController.refreshToken);


// register Doctor
router.post('/registerDoctor',vali.validateDoctorRegistration, authController.registerDoctor)

// register Student
router.post('/registerStudent', authController.registerStudent)

// Route لطلب استعادة كلمة المرور
router.post('/request-password-reset', vali.validateRequestPasswordReset , authController.requestPasswordReset);

router.get('/verify-reset-token',authController.verifyResetToken)

// Route لإعادة تعيين كلمة المرور
router.post('/reset-password', vali.validateResetPassword , authController.resetPassword);



module.exports = router;






// const checkRole = require('./middleware/role');
// router.get('/admin-only', checkRole(['admin']), adminController.getAdminData);
// router.get('/doctor-data', checkRole(['doctor']), doctorController.getDoctorData);

