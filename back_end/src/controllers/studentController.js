
const Student = require('../models/student');
const { validateStudent } = require('../utils/validation');
const { handleError } = require('../utils/errorHandler');


exports.createStudent = async (req, res) => {
  const { error } = validateStudent(req.body);
  if (error) {
    return res.status(400).json({ error: error.details[0].message });
  }

  try {
    const student = await Student.create(req.body);
    res.status(201).json(student);
  } catch (error) {
    handleError(error, res);
  }
};

// Additional CRUD operations...






