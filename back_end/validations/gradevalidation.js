
const { body } = require('express-validator');
 
const createGrade = [
  body('student_id')
    .isInt()
    .withMessage('Student ID must be an integer.')
    .notEmpty()
    .withMessage('Student ID is required.'),

  body('subject_id')
    .isString()
    .withMessage('Subject ID must be a string.')
    .isLength({ max: 10 })
    .withMessage('Subject ID must not exceed 10 characters.')
    .notEmpty()
    .withMessage('Subject ID is required.'),

  body('exam_grade')
    .optional()
    .isInt({ min: 0, max: 100 })
    .withMessage('Exam grade must be an integer between 0 and 100.'),

  body('work_grade')
    .optional()
    .isInt({ min: 0, max: 100 })
    .withMessage('Work grade must be an integer between 0 and 100.'),

  body('term')
    .isIn(['Term 1', 'Term 2'])
    .withMessage('Term must be either "Term 1" or "Term 2".')
    .notEmpty()
    .withMessage('Term is required.'),

  body('section')
    .isIn(['Computer', 'Communications', 'Civil', 'Architecture'])
    .withMessage('Section must be one of: Computer, Communications, Civil, Architecture.')
    .notEmpty()
    .withMessage('Section is required.'),

  body('level')
    .isIn(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'])
    .withMessage('Level must be one of: Level 1, Level 2, Level 3, Level 4, Level 5.')
    .notEmpty()
    .withMessage('Level is required.'),

  body('year_of_issue')
    .isISO8601()
    .withMessage('Year of issue must be a valid date (YYYY-MM-DD).')
    .notEmpty()
    .withMessage('Year of issue is required.'),

  body('is_absent')
    .optional()
    .isBoolean()
    .withMessage('Is Absent must be a boolean (true or false).'),

  body('status')
    .isIn(['Freshman', 'Repeater'])
    .withMessage('Status must be either "Freshman" or "Repeater".')
    .notEmpty()
    .withMessage('Status is required.'),
];

const updateGrade = [
  body('student_id')
    .optional()
    .isInt()
    .withMessage('Student ID must be an integer.'),

  body('subject_id')
    .optional()
    .isString()
    .withMessage('Subject ID must be a string.')
    .isLength({ max: 10 })
    .withMessage('Subject ID must not exceed 10 characters.'),

  body('exam_grade')
    .optional()
    .isInt({ min: 0, max: 100 })
    .withMessage('Exam grade must be an integer between 0 and 100.'),

  body('work_grade')
    .optional()
    .isInt({ min: 0, max: 100 })
    .withMessage('Work grade must be an integer between 0 and 100.'),

  body('term')
    .optional()
    .isIn(['Term 1', 'Term 2'])
    .withMessage('Term must be either "Term 1" or "Term 2".'),

  body('section')
    .optional()
    .isIn(['Computer', 'Communications', 'Civil', 'Architecture'])
    .withMessage('Section must be one of: Computer, Communications, Civil, Architecture.'),

  body('level')
    .optional()
    .isIn(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'])
    .withMessage('Level must be one of: Level 1, Level 2, Level 3, Level 4, Level 5.'),

  body('year_of_issue')
    .optional()
    .isISO8601()
    .withMessage('Year of issue must be a valid date (YYYY-MM-DD).'),

  body('is_absent')
    .optional()
    .isBoolean()
    .withMessage('Is Absent must be a boolean (true or false).'),

  body('status')
    .optional()
    .isIn(['Freshman', 'Repeater'])
    .withMessage('Status must be either "Freshman" or "Repeater".'),
];

module.exports = { createGrade, updateGrade };
