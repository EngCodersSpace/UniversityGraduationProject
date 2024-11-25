const { body } = require('express-validator');

const createExam = [
  body('subject_id')
    .isString()
    .notEmpty()
    .withMessage('Subject ID is required and must be a string'),

  body('exam_section')
    .isIn(['Computer', 'Communications', 'Civil', 'Architecture'])
    .withMessage('Exam section must be one of: Computer, Communications, Civil, Architecture'),

  body('exam_level')
    .isIn(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'])
    .withMessage('Exam level must be one of: Level 1, Level 2, Level 3, Level 4, Level 5'),

  body('exam_term')
    .isIn(['Term 1', 'Term 2'])
    .withMessage('Exam term must be one of: Term 1, Term 2'),

  body('exam_year')
    .isString()
    .notEmpty()
    .withMessage('Exam year is required and must be a string'),

  body('exam_date')
    .isISO8601()
    .withMessage('Exam date must be a valid date'),

  body('exam_time')
    .matches(/^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$/)
    .withMessage('Exam time must be in HH:MM:SS format'),

  body('exam_day')
    .isIn(['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'])
    .withMessage('Exam day must be one of: Saturday, Sunday, Monday, Tuesday, Wednesday, Thursday'),

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

  body('exam_section')
    .optional()
    .isIn(['Computer', 'Communications', 'Civil', 'Architecture'])
    .withMessage('Exam section must be one of: Computer, Communications, Civil, Architecture'),

  body('exam_level')
    .optional()
    .isIn(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'])
    .withMessage('Exam level must be one of: Level 1, Level 2, Level 3, Level 4, Level 5'),

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
