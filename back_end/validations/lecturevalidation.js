const { body,  query } = require('express-validator');
const { lecture } = require('../models');

const createLectureValidator = [
  body('subject_id')
    .isString()
    .isLength({ min: 1 })
    .withMessage('Subject ID is required and should be a valid string'),

  body('doctor_id')
    .isInt({ gt: 0 })
    .custom((value) => value > 0).withMessage('User ID must be greater than 0')
    .withMessage('Doctor ID is required and should be a valid integer'),

  body('lecture_section_id')
    .isInt({ gt: 0 })
    .custom((value) => value > 0).withMessage('User ID must be greater than 0')
    .withMessage('lecture-section-ID is required and should be a valid integer'),

  body('lecture_level_id')
    .isInt({ gt: 0 })
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
    .isInt({ gt: 0 })
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
  query('id')
    .isInt({ gt: 0 })
    .withMessage('ID must be a positive integer')
    .custom(async (value) => {
      const foundLecture = await lecture.findOne({ where: { id: value } });
      if (!foundLecture) {
        throw new Error('Lecture not found'); // this is the custom error message
      }
    }),

  body('subject_id')
    .optional()
    .isString()
    .isLength({ min: 1 })
    .withMessage('Subject ID should be a valid string'),

  body('doctor_id')
    .optional()
    .isInt({ gt: 0 })
    .withMessage('Doctor ID should be a valid integer'),

  body('lecture_section_id')
    .optional()
    .isInt({ gt: 0 })
    .withMessage('lecture-level-ID is required and should be a valid integer'),

  body('lecture_level_id')
    .optional()
    .isInt({ gt: 0 })
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
    .isInt({gt:0})
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
 