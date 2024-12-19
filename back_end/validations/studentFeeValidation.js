const { body, param } = require('express-validator');

const createStudentFeeValidator = [
  body('student_id')
    .isInt()
    .withMessage('Student ID is required and should be a valid integer'),

  body('section_id')
    .isInt()
    .withMessage('Section ID is required and should be a valid integer'),

  body('level_fees_id')
    .isInt()
    .withMessage('Level Fees ID is required and should be a valid integer'),

  body('term')
    .isIn(['Term 1', 'Term 2'])
    .withMessage('Term must be one of the following: Term 1, Term 2'),

  body('total_amount')
    .isDecimal({ decimal_digits: '1,2' })
    .withMessage('Total Amount is required and should be a valid decimal'),

  body('amount_paid')
    .isDecimal({ decimal_digits: '1,2' })
    .withMessage('Amount Paid is required and should be a valid decimal'),

  body('remaining_amount')
    .isDecimal({ decimal_digits: '1,2' })
    .withMessage('Remaining Amount is required and should be a valid decimal'),

  body('payment_status')
    .isObject()
    .withMessage('Payment Status is required and should be a valid JSON object'),

  body('payment_date')
    .optional()
    .isISO8601()
    .withMessage('Payment Date should be a valid ISO 8601 date'),

  body('receipt_number')
    .isString()
    .isLength({ min: 1 })
    .withMessage('Receipt Number is required and should be a valid string'),
];

const updateStudentFeeValidator = [
  param('id').isInt().withMessage('Student Fee ID must be a valid integer'),

  body('student_id')
    .optional()
    .isInt()
    .withMessage('Student ID should be a valid integer'),

  body('section_id')
    .optional()
    .isInt()
    .withMessage('Section ID should be a valid integer'),

  body('level_fees_id')
    .optional()
    .isInt()
    .withMessage('Level Fees ID should be a valid integer'),

  body('term')
    .optional()
    .isIn(['Term 1', 'Term 2'])
    .withMessage('Term must be one of the following: Term 1, Term 2'),

  body('total_amount')
    .optional()
    .isDecimal({ decimal_digits: '1,2' })
    .withMessage('Total Amount should be a valid decimal'),

  body('amount_paid')
    .optional()
    .isDecimal({ decimal_digits: '1,2' })
    .withMessage('Amount Paid should be a valid decimal'),

  body('remaining_amount')
    .optional()
    .isDecimal({ decimal_digits: '1,2' })
    .withMessage('Remaining Amount should be a valid decimal'),

  body('payment_status')
    .optional()
    .isObject()
    .withMessage('Payment Status should be a valid JSON object'),

  body('payment_date')
    .optional()
    .isISO8601()
    .withMessage('Payment Date should be a valid ISO 8601 date'),

  body('receipt_number')
    .optional()
    .isString()
    .isLength({ min: 1 })
    .withMessage('Receipt Number should be a valid string'),
];




module.exports = { 
    createStudentFeeValidator,
    updateStudentFeeValidator 
};
