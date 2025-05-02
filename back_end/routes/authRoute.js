// routes/authRoute.js
const express = require('express');
const router = express.Router();
const vali = require('../validations/authvalidation');
const authController = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');
const { uploadPhoto } = require('../utils/multerConfig');
const uploadProfilePicture = uploadPhoto('profile_pictures', 'user');


router.post('/login', authController.login);
router.post('/login/authToken', authMiddleware.verifyToken);//
router.post('/logout', authController.logout);
// router.get('/me', authMiddleware.verifyToken, authController.getCurrentUser);
router.post('/refresh', authController.refreshToken);

// router.post('/register', uploadProfilePicture.single('profile_picture'), (req, res) => {exports.registerStudent(req, res);});

router.post(
    '/registerDoctor',
    authController.registerDoctor
); //    uploadProfilePicture.single('profile_picture'),


router.post(
    '/registerStudent', 
    authController.registerStudent 
); // uploadProfilePicture.single('profile_picture'), 

router.post('/upload-photo-user',authController.uploadPhotoForuser);
router.post('/request-password-reset', vali.validateRequestPasswordReset , authController.requestPasswordReset);
router.get('/verify-reset-token',authController.verifyResetToken);
router.post('/reset-password', vali.validateResetPassword , authController.resetPassword);
router.post('/change-password', authController.changePass);


module.exports = router;