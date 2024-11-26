const { validationResult } = require('express-validator');
const { lecture, subject, doctor } = require('../models'); // Adjust path as needed

const createLecture = async (req, res) => {
  try {
    // Validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { subject_id, doctor_id, lecture_section, lecture_level, term, year, lecture_time, lecture_duration, lecture_day, lecture_room } = req.body;

    // Create new lecture
    const newLecture = await lecture.create({
      subject_id,
      doctor_id,
      lecture_section,
      lecture_level,
      term,
      year,
      lecture_time,
      lecture_duration,
      lecture_day,
      lecture_room,
    });

    res.status(201).json({
      message: 'Lecture created successfully',
      data: newLecture,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error creating lecture', error: error.message });
  }
};

const getLectures = async (req, res) => {
  try {
    const lectures = await lecture.findAll({
      include: [
        {
          model: subject,
          as: 'subject', // the alias set in associations
          attributes: ['subject_name'], // adjust the fields as needed
        },
        {
          model: doctor,
          as: 'doctor', // alias for doctor association
          attributes: ['doctor_id'], // adjust the fields as needed
        },
      ],
    });
    res.status(200).json({ data: lectures });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving lectures', error: error.message });
  }
};

const getLectureById = async (req, res) => {
  try {
    const { id } = req.params;

    const lectureDetails = await lecture.findOne({
      where: { id },
      include: [
        {
          model: subject,
          as: 'subject',
        },
        {
          model: doctor,
          as: 'doctor',
        },
      ],
    });

    if (!lectureDetails) {
      return res.status(404).json({ message: 'Lecture not found' });
    }

    res.status(200).json({ data: lectureDetails });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving lecture', error: error.message });
  }
};

const updateLecture = async (req, res) => {
  try {
    const { id } = req.params;
    const { subject_id, doctor_id, lecture_section, lecture_level, term, year, lecture_time, lecture_duration, lecture_day, lecture_room } = req.body;

    // Find and update the lecture
    const updatedLecture = await lecture.update(
      {
        subject_id,
        doctor_id,
        lecture_section,
        lecture_level,
        term,
        year,
        lecture_time,
        lecture_duration,
        lecture_day,
        lecture_room,
      },
      {
        where: { id },
        returning: true, // returns the updated data
      }
    );

    if (updatedLecture[0] === 0) {
      return res.status(404).json({ message: 'Lecture not found' });
    }

    res.status(200).json({
      message: 'Lecture updated successfully',
      data: updatedLecture[1][0], // returning updated data
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error updating lecture', error: error.message });
  }
};

const deleteLecture = async (req, res) => {
  try {
    const { id } = req.params;

    const deleted = await lecture.destroy({
      where: { id },
    });

    if (deleted === 0) {
      return res.status(404).json({ message: 'Lecture not found' });
    }

    res.status(200).json({
      message: 'Lecture deleted successfully',
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error deleting lecture', error: error.message });
  }
};

module.exports = {
  createLecture,
  getLectures,
  getLectureById,
  updateLecture,
  deleteLecture,
};
