// /validations/studyPlanElementValidations.js

const { body } = require('express-validator');

const studyPlanElementValidation = [
  body('study_plan_id')
    .isInt().withMessage('Study Plan ID must be an integer'),

  body('subject_id')
    .notEmpty().withMessage('Subject ID is required')
    .isLength({ min: 1, max: 10 }).withMessage('Subject ID should be between 1 and 10 characters'),

  body('doctor_id')
    .optional()
    .isInt().withMessage('Doctor ID must be an integer'),

  body('section')
    .isIn(['Computer', 'Communications', 'Civil', 'Architecture'])
    .withMessage('Section must be one of the predefined values'),

  body('level')
    .isIn(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'])
    .withMessage('Level must be one of the predefined values'),

  body('number_of_units')
    .isInt({ min: 1, max: 10 }).withMessage('Number of units must be between 1 and 10'),

  body('term')
    .isIn(['Term 1', 'Term 2'])
    .withMessage('Term must be one of the predefined values'),
];

module.exports ={studyPlanElementValidation} ;
