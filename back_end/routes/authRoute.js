// routes/authRoute.js
const express = require('express');
const router = express.Router();
const vali = require('../validations/authvalidation');
const CRUD = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');
const {checkPermission} = require('../middleware/roleMiddleware');


router.get('/', CRUD.welcome);
router.post('/login', CRUD.login);
router.post('/login/authToken', authMiddleware.verifyToken);//
router.post('/logout', CRUD.logout);
router.post('/refresh', CRUD.refreshToken);
router.post('/registerDoctor',checkPermission('users', 'write'),CRUD.registerDoctor); 
router.post('/registerStudent',checkPermission('users', 'write'), CRUD.registerStudent ); 
router.post('/upload-photo-user',checkPermission('users', 'write'),CRUD.uploadPhotoForuser);
router.post('/request-password-reset', vali.validateRequestPasswordReset , CRUD.requestPasswordReset);
router.get('/verify-reset-token',CRUD.verifyResetToken);
router.post('/reset-password', vali.validateResetPassword , CRUD.resetPassword);
router.post('/change-password', CRUD.changePass);


module.exports = router;