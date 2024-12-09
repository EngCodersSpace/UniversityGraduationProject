const { body } = require('express-validator');

const { Op } = require('sequelize');
const {user} = require('../models'); 

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

    body('user_name')
        .notEmpty().withMessage('User Name is required')
        .isString().withMessage('User Name must be a String'),

    body('user_section_id')
        .notEmpty().withMessage('User Section ID is required')
        .isInt().withMessage('User Section ID must be a number')
        .custom((value) => value > 0).withMessage('User Section ID must be greater than 0'),
    
    body('date_of_birth')
        .notEmpty().withMessage('Date Of Birth is required')
        .isDate().withMessage('Date Of Birth must be a Date'),

    body('collegeName')
        .notEmpty().withMessage('collegeName is required')
        .isString().withMessage('collegeName must be a String'),

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

    body('permission')
        .notEmpty().withMessage('permission is required')
        .isString().withMessage('permission must be a String'),

    body('doctor.academic_degree')
        .notEmpty().withMessage('Academic degree is required')
        .isString().withMessage('Academic degree must be a String'),

    body('doctor.administrative_position')
        .notEmpty().withMessage('Administrative position is required')
        .isString().withMessage('Administrative position must be a String'),
];

const validateStudentRegistration = [
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


    body('user_name')
        .notEmpty().withMessage('User Name is required')
        .isString().withMessage('User Name must be a String'),

    body('user_section_id')
        .notEmpty().withMessage('User Section ID is required')
        .isInt().withMessage('User Section ID must be a number')
        .custom((value) => value > 0).withMessage('User Section ID must be greater than 0'),
    
    body('date_of_birth')
        .notEmpty().withMessage('Date Of Birth is required')
        .isDate().withMessage('Date Of Birth must be a Date'),

    body('collegeName')
        .notEmpty().withMessage('collegeName is required')
        .isString().withMessage('collegeName must be a String'),

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

    body('permission')
        .notEmpty().withMessage('permission is required')
        .isString().withMessage('permission must be a String'),
    
   
    body('student.enrollment_year')
        .isDate().withMessage('Enrollment year must be a valid date'),

    body('student.student_level_id')
        .isNumeric().withMessage('Student level ID must be a number')
        .notEmpty().withMessage('Student level ID is required'),

    body('student.student_system')
        .isIn(['General', 'Free Seat', 'Paid'])
        .withMessage('Invalid student system'),

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


