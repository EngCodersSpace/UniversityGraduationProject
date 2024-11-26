const { body, param } = require('express-validator');

const createLectureValidator = [
  body('subject_id')
    .isString()
    .isLength({ min: 1 })
    .withMessage('Subject ID is required and should be a valid string'),

  body('doctor_id')
    .isInt()
    .withMessage('Doctor ID is required and should be a valid integer'),

  body('lecture_section')
    .isIn(['Computer', 'Communications', 'Civil', 'Architecture'])
    .withMessage('Lecture section must be one of the following: Computer, Communications, Civil, Architecture'),

  body('lecture_level')
    .isIn(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'])
    .withMessage('Lecture level must be one of the following: Level 1, Level 2, Level 3, Level 4, Level 5'),

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
    .withMessage('Doctor ID should be a valid integer'),

  body('lecture_section')
    .optional()
    .isIn(['Computer', 'Communications', 'Civil', 'Architecture'])
    .withMessage('Lecture section must be one of the following: Computer, Communications, Civil, Architecture'),

  body('lecture_level')
    .optional()
    .isIn(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'])
    .withMessage('Lecture level must be one of the following: Level 1, Level 2, Level 3, Level 4, Level 5'),

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
