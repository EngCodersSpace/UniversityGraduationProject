const { body } = require('express-validator');


const validateRequestPasswordReset = [
    body('email')
        .isEmail().withMessage('Invalid email format')
        .notEmpty().withMessage('Email is required'),
];

const validateResetPassword = [
    body('token')
        .notEmpty().withMessage('Token is required'),
    body('newPassword')
        .isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
        .notEmpty().withMessage('New password is required'),
];

const validateUserLogin = [
    body('user_id').notEmpty().withMessage('User ID is required'),
    body('password').notEmpty().withMessage('Password is required'),
];

const validateDoctorRegistration = [
    // Validate common user fields
    body('user_id')
        .notEmpty().withMessage('User ID is required')
        .isNumeric().withMessage('User ID must be a number')
        .custom((value) => value.trim() !== "").withMessage('User ID cannot be empty')
        .custom((value) => value > 0).withMessage('User ID must be greater than 0'),

    body('email')
        .isEmail().withMessage('Invalid email format'),

    body('password')
        .isLength({ min: 8 }).withMessage('Password must be at least 8 characters long')
        .matches(/[a-zA-Z]/).withMessage('Password must include at least one letter')
        .matches(/\d/).withMessage('Password must include at least one number')
        .matches(/[@$!%*?&]/).withMessage('Password must include at least one special character (@, $, !, %, *, ?, &)')
        .not().matches(/\s/).withMessage('Password cannot contain spaces'),

    body('user_name')
        .notEmpty().withMessage('User name is required'),

    body('doctor.doctor_name')
        .notEmpty().withMessage('Doctor name is required'),

    body('doctor.department')
        .notEmpty().withMessage('Department is required'),

    body('doctor.academic_degree')
        .notEmpty().withMessage('Academic degree is required'),

    body('doctor.administrative_position')
        .notEmpty().withMessage('Administrative position is required'),
];


const validateStudentRegistration = [
    // Validate common user fields
    body('user_id')
        .notEmpty().withMessage('User ID is required')
        .isNumeric().withMessage('User ID must be a number')
        .custom((value) => value.trim() !== "").withMessage('User ID cannot be empty')
        .custom((value) => value > 0).withMessage('User ID must be greater than 0'),

    body('email')
        .isEmail().withMessage('Invalid email format'),

        body('password')
        .isLength({ min: 8 }).withMessage('Password must be at least 8 characters long')
        .matches(/[a-zA-Z]/).withMessage('Password must include at least one letter')
        .matches(/\d/).withMessage('Password must include at least one number')
        .matches(/[@$!%*?&]/).withMessage('Password must include at least one special character (@, $, !, %, *, ?, &)')
        .not().matches(/\s/).withMessage('Password cannot contain spaces'),

    body('user_name')
        .notEmpty().withMessage('User name is required'),

    // Validate student-specific fields
    body('student.student_name')
        .notEmpty().withMessage('Student name is required'),

    body('student.student_section')
        .isIn(['Computer', 'Communications', 'Civil', 'Architecture'])
        .withMessage('Invalid student section'),

    body('student.enrollment_year')
        .isDate().withMessage('Enrollment year must be a valid date'),

    body('student.student_level')
        .isIn(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'])
        .withMessage('Invalid student level'),

    body('student.student_system')
        .isIn(['General', 'Free Seat', 'Paid'])
        .withMessage('Invalid student system'),

    body('student.profile_picture')
        .optional()
        .isString().withMessage('Profile picture must be a valid string'),

    body('student.study_plan_id')
        .optional()
        .isNumeric().withMessage('Study plan ID must be a number'),
];


module.exports = {
    validateRequestPasswordReset,
    validateResetPassword,
    validateUserLogin,
    validateDoctorRegistration,
    validateStudentRegistration
};




