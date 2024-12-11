const { body } = require('express-validator');

const createExam = [
  body('subject_id')
    .notEmpty().withMessage('Exam section ID required')
    .isString().withMessage('Subject ID must be a string'),

  body('exam_section_id')
    .isInt().withMessage('Exam section ID must be a number')
    .notEmpty().withMessage('Exam section ID required'),

  body('exam_level_id')
    .isInt().withMessage('Exam level ID must be a number')
    .notEmpty().withMessage('Exam level ID required'),
    
  body('exam_term')
    .isIn(['Term 1', 'Term 2'])
    .withMessage('Exam term must be one of: Term 1, Term 2')
    .notEmpty()
    .withMessage('Exam term is required.'),

  body('exam_year')
    .isString()
    .notEmpty()
    .withMessage('Exam year is required and must be a string'),

  body('exam_date')
    .isISO8601()
    .withMessage('Exam date must be a valid date')
    .notEmpty()
    .withMessage('Exam date is required.'),

  body('exam_time')
    .matches(/^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$/)
    .withMessage('Exam time must be in HH:MM:SS format')
    .notEmpty()
    .withMessage('Exam time is required.'),

  body('exam_day')
    .isIn(['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'])
    .withMessage('Exam day must be one of: Saturday, Sunday, Monday, Tuesday, Wednesday, Thursday')
    .notEmpty()
    .withMessage('Exam day is required.'),

  body('exam_room')
    .isString()
    .notEmpty()
    .withMessage('Exam room is required and must be a string'),
];

const updateExam = [
  body('subject_id')
    .optional()
    .isString()
    .notEmpty()
    .withMessage('Subject ID must be a string'),

  body('exam_section_id')
    .optional()
    .isInt().withMessage('Exam section ID must be a number'),

  body('exam_level_id')
    .optional()
    .isInt().withMessage('Exam level ID must be a number')
    .notEmpty().withMessage('Exam level ID required'),

  body('exam_term')
    .optional()
    .isIn(['Term 1', 'Term 2'])
    .withMessage('Exam term must be one of: Term 1, Term 2'),

  body('exam_year')
    .optional()
    .isString()
    .notEmpty()
    .withMessage('Exam year must be a string'),

  body('exam_date')
    .optional()
    .isISO8601()
    .withMessage('Exam date must be a valid date'),

  body('exam_time')
    .optional()
    .matches(/^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$/)
    .withMessage('Exam time must be in HH:MM:SS format'),

  body('exam_day')
    .optional()
    .isIn(['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'])
    .withMessage('Exam day must be one of: Saturday, Sunday, Monday, Tuesday, Wednesday, Thursday'),

  body('exam_room')
    .optional()
    .isString()
    .notEmpty()
    .withMessage('Exam room must be a string'),
];

module.exports = {
  createExam,
  updateExam,
};
