const { body } = require('express-validator');

// التحقق من طلب إعادة تعيين كلمة المرور
const validateRequestPasswordReset = [
    body('email')
        .isEmail().withMessage('Invalid email format')
        .notEmpty().withMessage('Email is required'),
];

// التحقق من إعادة تعيين كلمة المرور
const validateResetPassword = [
    body('token')
        .notEmpty().withMessage('Token is required'),
    body('newPassword')
        .isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
        .notEmpty().withMessage('New password is required'),
];

// التحقق من تسجيل الدخول
const validateUserLogin = [
    body('user_id').notEmpty().withMessage('User ID is required'),
    body('password').notEmpty().withMessage('Password is required'),
];

// التحقق من التسجيل
const validateUserRegistration = [
    body('user_id').notEmpty().withMessage('User ID is required'),
    body('email').isEmail().withMessage('Invalid email format'),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters long'),
];

module.exports = {
    validateRequestPasswordReset,
    validateResetPassword,
    validateUserLogin,
    validateUserRegistration
};




