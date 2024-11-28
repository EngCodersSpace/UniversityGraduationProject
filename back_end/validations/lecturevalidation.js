const { body, param } = require('express-validator');

const createLectureValidator = [
  body('subject_id')
    .isString()
    .isLength({ min: 1 })
    .withMessage('Subject ID is required and should be a valid string'),

  body('doctor_id')
    .isInt()
    .custom((value) => value > 0).withMessage('User ID must be greater than 0')
    .withMessage('Doctor ID is required and should be a valid integer'),

  body('lecture_section_id')
    .isIn()
    .custom((value) => value > 0).withMessage('User ID must be greater than 0')
    .withMessage('lecture-section-ID is required and should be a valid integer'),

  body('lecture_level_id')
    .isIn()
    .custom((value) => value > 0).withMessage('User ID must be greater than 0')
    .withMessage('lecture-level-ID is required and should be a valid integer'),

  body('term')
    .isIn(['Term 1', 'Term 2'])
    .withMessage('Term must be one of the following: Term 1, Term 2'),

  body('year')
    .isString()
    .isLength({ min: 1 })
    .withMessage('Year is required and should be a valid string'),

  body('lecture_time')
    .isString()
    .withMessage('Lecture time is required and should be a valid time string'),

  body('lecture_duration')
    .isString()
    .withMessage('Lecture duration is required and should be a valid string'),

  body('lecture_day')
    .isIn(['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'])
    .withMessage('Lecture day must be one of the following: Saturday, Sunday, Monday, Tuesday, Wednesday, Thursday'),

  body('lecture_room')
    .isString()
    .isLength({ min: 1 })
    .withMessage('Lecture room is required and should be a valid string'),
];

const updateLectureValidator = [
  param('id').isInt().withMessage('Lecture ID must be a valid integer'),

  body('subject_id')
    .optional()
    .isString()
    .isLength({ min: 1 })
    .withMessage('Subject ID should be a valid string'),

  body('doctor_id')
    .optional()
    .isInt()
    .custom((value) => value > 0).withMessage('User ID must be greater than 0')
    .withMessage('Doctor ID should be a valid integer'),

  body('lecture_section_id')
    .optional()
    .custom((value) => value > 0).withMessage('User ID must be greater than 0')
    .withMessage('lecture-level-ID is required and should be a valid integer'),

  body('lecture_level_id')
    .optional()
    .custom((value) => value > 0).withMessage('User ID must be greater than 0')
    .withMessage('lecture-level-ID is required and should be a valid integer'),

  body('term')
    .optional()
    .isIn(['Term 1', 'Term 2'])
    .withMessage('Term must be one of the following: Term 1, Term 2'),

  body('year')
    .optional()
    .isString()
    .isLength({ min: 1 })
    .withMessage('Year should be a valid string'),

  body('lecture_time')
    .optional()
    .isString()
    .withMessage('Lecture time should be a valid time string'),

  body('lecture_duration')
    .optional()
    .isString()
    .withMessage('Lecture duration should be a valid string'),

  body('lecture_day')
    .optional()
    .isIn(['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'])
    .withMessage('Lecture day must be one of the following: Saturday, Sunday, Monday, Tuesday, Wednesday, Thursday'),

  body('lecture_room')
    .optional()
    .isString()
    .isLength({ min: 1 })
    .withMessage('Lecture room should be a valid string'),
];

module.exports = { createLectureValidator, updateLectureValidator };
