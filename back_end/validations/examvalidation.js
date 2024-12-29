const { body , query} = require('express-validator');
const { exam, subject } = require('../models');

const createExam = [
  body('subject_id')
    .notEmpty().withMessage('Exam section ID required')
    .isString().withMessage('Subject ID must be a string')
    .custom(async (value) => {
        const existingSubject = await subject.findOne({ where: { subject_id: value } });
        if (!existingSubject) {
            throw new Error('Subject not found');
        }
        return true;
    }),


  body('exam_section_id')
    .isInt().withMessage('Exam section ID must be a number')
    .notEmpty().withMessage('Exam section ID required'),

  body('exam_level_id')
    .isInt().withMessage('Exam level ID must be a number')
    .notEmpty().withMessage('Exam level ID required'),
    
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
  query('exam_id')
    .isInt({ gt: 0 })
    .withMessage('Exam ID must be a positive integer')
    .custom(async (exam_id) => {
      const foundExam = await exam.findOne({ where: { exam_id :exam_id} });
      if (!foundExam) {
        throw new Error('Exam not found');
      }
    }).withMessage('Invalid Exam ID'),

  body('subject_id')
    .optional()
    .isString()
    .notEmpty()
    .withMessage('Subject ID must be a string')
    .bail() // Stop validation chain if this fails
    .custom(async (subject_id) => {
      if (subject_id) {
        const foundSubject = await subject.findOne({ where: { subject_id } });
        if (!foundSubject) {
          throw new Error('Subject not found');
        }
      }
    }),

  body('exam_section_id')
    .optional()
    .isInt().withMessage('Exam section ID must be a number'),

  body('exam_level_id')
    .optional()
    .isInt().withMessage('Exam level ID must be a number')
    .notEmpty().withMessage('Exam level ID required'),


  body('exam_date')
    .optional()
    .isISO8601()
    .withMessage('Exam date must be a valid date')
    .notEmpty().withMessage('Exam date is required'),

  body('exam_time')
    .optional()
    .matches(/^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$/)
    .withMessage('Exam time must be in HH:MM:SS format')
    .notEmpty().withMessage('Exam time is required'),

  body('exam_day')
    .optional()
    .isIn(['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'])
    .withMessage('Exam day must be one of: Saturday, Sunday, Monday, Tuesday, Wednesday, Thursday')
    .notEmpty().withMessage('Exam day is required'),

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