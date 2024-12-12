const { body } = require('express-validator');
const {study_plan} = require('../models'); 

const StudyPlanValidator = [
  body('study_plan_name')
    .isString().withMessage('Study plan should be a valid Text')
    .notEmpty().withMessage('Study plan is required')
    .custom(async (value) => {
      const existingStudyPlan = await study_plan.findOne({ where: { study_plan_name: value } });
      if (existingStudyPlan) {
          throw new Error('study plan name already exists');
      }
      return true;
    }),

];

module.exports = { StudyPlanValidator };

