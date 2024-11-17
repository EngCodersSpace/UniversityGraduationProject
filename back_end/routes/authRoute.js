// routes/authRoute.js
const express = require('express');
const router = express.Router();
const vali = require('../validations/uservalidation');
const authController = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');


// Route for user login
router.post('/login', authController.login);

// Route for token verification
router.post('/login/authToken', authMiddleware.verifyToken);

router.post('/register', authController.registerUser)

// Route لطلب استعادة كلمة المرور
router.post('/request-password-reset', authController.requestPasswordReset, vali.validateRequestPasswordReset , vali.validateResetPassword);
// router.post('/request-password-reset', authController.requestPasswordReset);

// Route لإعادة تعيين كلمة المرور
router.post('/reset-password', authController.resetPassword, vali.validateResetPassword);
// router.post('/reset-password', authController.resetPassword);


// إضافة المسار لعرض بيانات المستخدم المسجل دخوله حالياً
router.get('/me', authMiddleware.verifyToken, authController.getCurrentUser);

//To refresh Token
router.post('/refresh', authController.refreshToken);


module.exports = router;






// const checkRole = require('./middleware/role');
// router.get('/admin-only', checkRole(['admin']), adminController.getAdminData);
// router.get('/doctor-data', checkRole(['doctor']), doctorController.getDoctorData);

