// const { body, param } = require('express-validator');

// exports.doctorvalidation = [
//   body('name').isString().withMessage('Name must be a string'),
//   body('userId').isInt().withMessage('User ID must be an integer'),
//   // Add other validations as needed.
// ];

const Joi = require('joi');

// Joi validation schema for doctor
const doctorSchema = Joi.object({
    doctor_id: Joi.number().min(1).required().messages({
        'number.base': 'doctor_id must be a number',
        'number.min': 'doctor_id must be greater than 0',
        'any.required': 'doctor_id is required'
    }),
    doctor_name: Joi.string().required().messages({
        'string.empty': 'doctor_name cannot be empty',
        'any.required': 'doctor_name is required'
    }),
    department: Joi.string().required().messages({
        'string.empty': 'department cannot be empty',
        'any.required': 'department is required'
    }),
    status: Joi.string().allow(null),
    academic_degree: Joi.string()
        .valid('Doctor', 'Professor', 'Master', 'Bachelor')
        .required().messages({
            'any.only': 'academic_degree must be one of [Doctor, Professor, Master, Bachelor]',
            'any.required': 'academic_degree is required'
        }),
    administrative_position: Joi.string()
        .valid('Dean', 'Vice Dean', 'Lecturer', 'Department Chair', 'None')
        .default('None').messages({
            'any.only': 'administrative_position must be one of [Dean, Vice Dean, Lecturer, Department Chair, None]',
        }),
});

// Joi validation schema for updating a doctor
const updateDoctorSchema = doctorSchema.fork(
    ['doctor_id'],
    (field) => field.forbidden() // Prevent updating doctor_id
);

module.exports = {
    doctorSchema,
    updateDoctorSchema,
};

