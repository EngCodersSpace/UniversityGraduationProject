const { body } = require('express-validator');

const { Op } = require('sequelize');
const {user} = require('../models');  // Import your user model

const validateRequestPasswordReset = [
    body('email')
        .isEmail().withMessage('Invalid email format')
        .notEmpty().withMessage('Email is required'),
];

const validateResetPassword = [
    // body('code').isNumeric().isLength({ min: 6, max: 6 }).withMessage('Enter a valid 6-digit code'),
    // body('token').isString(),
    body('newPassword')
        .isLength({ min: 8 }).withMessage('Password must be at least 8 characters long')
        .bail() // Stops further checks if the password length is invalid
        .matches(/[a-zA-Z]/).withMessage('Password must include at least one letter')
        .matches(/\d/).withMessage('Password must include at least one number')
        .matches(/[@$!%*?&]/).withMessage('Password must include at least one special character (@, $, !, %, *, ?, &)') 
        .not().matches(/\s/).withMessage('Password cannot contain spaces'),
    body('confirmPassword').custom((value, { req }) => {
        if (value !== req.body.newPassword) {
            throw new Error('Passwords do not match');
        }
        return true;
    }),
];

const validateUserLogin = [
    body('user_id').notEmpty().withMessage('User ID is required'),
    body('password').notEmpty().withMessage('Password is required'),
];

const validateDoctorRegistration = [
    body('user_id')
        .notEmpty().withMessage('User ID is required')
        .isInt().withMessage('User ID must be a number')
        .custom((value) => value > 0).withMessage('User ID must be greater than 0')
        .custom(async (value) => {
            const existingUser = await user.findOne({ where: { user_id: value } });
            if (existingUser) {
                throw new Error('User ID already exists');
            }
            return true;
        }),

    body('email')
        .notEmpty().withMessage('Email is required')
        .isEmail().withMessage('Invalid email format')
        .custom(async (value) => {
            const existingUser = await user.findOne({ where: { email: value } });
            if (existingUser) {
                throw new Error('Email already registered');
            }
            return true;
        }),

    body('password')
        .notEmpty().withMessage('password is required')
        .isLength({ min: 8 }).withMessage('Password must be at least 8 characters long')
        .matches(/[a-zA-Z]/).withMessage('Password must include at least one letter')
        .matches(/\d/).withMessage('Password must include at least one number')
        .matches(/[@$!%*?&]/).withMessage('Password must include at least one special character (@, $, !, %, *, ?, &)')
        .not().matches(/\s/).withMessage('Password cannot contain spaces'),

    body('user_name')
        .notEmpty().withMessage('User name is required'),

    body('doctor.department')
        .notEmpty().withMessage('Department is required'),

    body('doctor.academic_degree')
        .notEmpty().withMessage('Academic degree is required'),

    body('doctor.administrative_position')
        .notEmpty().withMessage('Administrative position is required'),
];

const validateStudentRegistration = [
    body('user_id')
        .notEmpty().withMessage('User ID is required')
        .isInt().withMessage('User ID must be a number')
        .custom((value) => value > 0).withMessage('User ID must be greater than 0')
        .custom(async (value, { req }) => {
            const { email } = req.body;
            const existingUser = await user.findOne({
                where: {
                    [Op.or]: [{ user_id: value }, { email }]
                }
            });
            if (existingUser) {
                if (existingUser.user_id === value) {
                    throw new Error('User ID already exists');
                }
                if (existingUser.email === email) {
                    throw new Error('Email already registered');
                }
            }
            return true;
        }),

    body('email')
        .isEmail().withMessage('Invalid email format')
        .notEmpty().withMessage('Email is required')
        .custom(async (value, { req }) => {
            const { user_id } = req.body;
            const existingUser = await user.findOne({
                where: {
                    [Op.or]: [{ user_id }, { email: value }]
                }
            });
            if (existingUser) {
                if (existingUser.email === value) {
                    throw new Error('Email already registered');
                }
                if (existingUser.user_id === user_id) {
                    throw new Error('User ID already exists');
                }
            }
            return true;
        }),

    // Validate Password
    body('password')
        .isLength({ min: 8 }).withMessage('Password must be at least 8 characters long')
        .matches(/[a-zA-Z]/).withMessage('Password must include at least one letter')
        .matches(/\d/).withMessage('Password must include at least one number')
        .matches(/[@$!%*?&]/).withMessage('Password must include at least one special character (@, $, !, %, *, ?, &)')
        .not().matches(/\s/).withMessage('Password cannot contain spaces'),

    // Validate User Name
    body('user_name')
        .notEmpty().withMessage('User name is required'),

    // Validate Profile Picture
    body('profile_picture')
        .isString().withMessage('Profile picture must be a valid string (Path)'),

    // Validate Student Section ID
    body('student.student_section_id')
        .isNumeric().withMessage('Student section ID must be a number')
        .notEmpty().withMessage('Student section ID is required'),

    // Validate Enrollment Year
    body('student.enrollment_year')
        .isDate().withMessage('Enrollment year must be a valid date'),

    // Validate Student Level ID
    body('student.student_level_id')
        .isNumeric().withMessage('Student level ID must be a number')
        .notEmpty().withMessage('Student level ID is required'),

    // Validate Student System
    body('student.student_system')
        .isIn(['General', 'Free Seat', 'Paid'])
        .withMessage('Invalid student system'),

    // Validate Study Plan ID
    body('student.study_plan_id')
        .isNumeric().withMessage('Study plan ID must be a number')
        .notEmpty().withMessage('Student plan ID is required'),
];

module.exports = {
    validateRequestPasswordReset,
    validateResetPassword,
    validateUserLogin,
    validateDoctorRegistration,
    validateStudentRegistration
};


