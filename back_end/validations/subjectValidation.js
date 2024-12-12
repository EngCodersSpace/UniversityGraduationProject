const { body } = require('express-validator');
const {subject} = require('../models'); 

const validateSubjectCreate = [
    body('subject_id')
        .notEmpty().withMessage('Subject ID is required')
        .isString().withMessage('Subject ID must be a String')
        .custom(async (value) => {
            const existingSubject = await subject.findOne({ where: { subject_id: value } });
            if (existingSubject) {
                throw new Error('Subject ID already exists');
            }
            return true;
        }),

    body('subject_name')
        .notEmpty().withMessage('User Name is required')
        .isString().withMessage('User Name must be a String'),

    body('number_of_units')
        .notEmpty().withMessage('Number Of Units is required')
        .isInt().withMessage('Number Of Units must be a number')
        .custom((value) => value > 0).withMessage('Number Of Units must be greater than 0'),
    
    body('subject_description')
        .notEmpty().withMessage('Subject Description is required')
        .isString().withMessage('Subject Description must be a String'),
];

const validateSubjectUpdate = [
    body('subject_id')
        .optional()
        .notEmpty().withMessage('Subject ID is required')
        .isString().withMessage('Subject ID must be a String'),
        

    body('subject_name')
        .optional()
        .notEmpty().withMessage('User Name is required')
        .isString().withMessage('User Name must be a String'),

    body('number_of_units')
        .optional()
        .notEmpty().withMessage('Number Of Units is required')
        .isInt().withMessage('Number Of Units must be a number')
        .custom((value) => value > 0).withMessage('Number Of Units must be greater than 0'),
    
    body('subject_description')
        .optional()
        .notEmpty().withMessage('Subject Description is required')
        .isString().withMessage('Subject Description must be a String'),
];

module.exports = {
    validateSubjectCreate,
    validateSubjectUpdate
};
