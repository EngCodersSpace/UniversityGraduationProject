const Joi = require('joi');

const studentSchema = Joi.object({
  name: Joi.string().min(3).required(),
  email: Joi.string().email().required(),
  // Additional fields...
});

const validateStudent = (student) => {
  return studentSchema.validate(student);
};

module.exports = {
  validateStudent,
};




