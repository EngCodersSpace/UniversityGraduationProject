// const { body, param } = require('express-validator');

// exports.doctorvalidation = [
//   body('name').isString().withMessage('Name must be a string'),
//   body('userId').isInt().withMessage('User ID must be an integer'),
//   // Add other validations as needed.
// ];

const Joi = require('joi');

// Joi validation schema for doctor
const doctorSchema = Joi.object({
    doctor_id: Joi.number().required(),
    doctor_name: Joi.string().required(),
    department: Joi.string().required(),
    status: Joi.string().allow(null),
    academic_degree: Joi.string()
        .valid('Doctor', 'Professor', 'Master', 'Bachelor')
        .required(),
    administrative_position: Joi.string()
        .valid('Dean', 'Vice Dean', 'Lecturer', 'Department Chair', 'None')
        .default('None'),
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


