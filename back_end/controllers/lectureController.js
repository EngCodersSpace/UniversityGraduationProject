const { validationResult } = require('express-validator');
const { lecture, subject, doctor ,section , level } = require('../models'); 
const { Sequelize} = require('sequelize');

const createLecture = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    const {} = req.body;

    const newLecture = await lecture.create(req.body);

    res.status(201).json({
      message: 'Lecture created successfully',
      data: newLecture,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error creating lecture', error: error.message });
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




const getLectures = async (req, res) => {
  try {
    const lectures = await lecture.findAll();
    res.status(200).json({message:'getAllLectures', data: lectures });
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
          as: 'subject'
        },
        {
          model: doctor,
          as: 'doctor'
        },
        {
          model:section,
          as:'section'
        },
        {
          model:level,
          as:'level'
        },
      ],
    });

    if (!lectureDetails) {
      return res.status(404).json({ message: 'Lecture not found' });
    }

    res.status(200).json({message: `get lecture by id : ${id} `, data: lectureDetails });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving lecture', error: error.message });
  }
};

const getLecturesBySection = async (req, res) => {
  try {
    const { sectionId } = req.params; 
    const lectures = await lecture.findAll({
      where: {
        lecture_section_id: sectionId,
      },
      include: [
        { model: subject, as: 'subject' }, 
        { model: doctor, as:'doctor' },  
      ],
    });

    if (!lectures.length) {
      return res.status(404).json({ message: 'No lectures found for this section' });
    }

    res.status(200).json({ message: `Lectures for section id: ${sectionId}`, data: lectures });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving lectures by section', error: error.message });
  }
};

const getLecturesByLevel = async (req, res) => {
  try {
    const { levelId } = req.params; 

    const lectures = await lecture.findAll({
      where: {
        lecture_level_id: levelId,
      },
      include: [
        { model: subject, as: 'subject' },
        { model: doctor, as:'doctor' },
      ],
    });

    if (!lectures.length) {
      return res.status(404).json({ message: 'No lectures found for this level' });
    }

    res.status(200).json({ message: `Lectures for level id: ${levelId}`, data: lectures });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving lectures by level', error: error.message });
  }
};

const getLecturesByDoctor = async (req, res) => {
  try {
    const { doctorId } = req.params;      
    const lectures = await lecture.findAll({
      where: {
        doctor_id: doctorId,
      },
      include: [
        { model: subject, as: 'subject' },
        { model: section, as: 'section' },
        { model: level,   as: 'level' },
      ],
      attributes: {
          include: [
              [Sequelize.fn('COUNT', Sequelize.col('lecture.id')), 'lectureCount'] 
          ]
      },
      group: ['lecture.id'],
    });

    if (!lectures.length) {
      return res.status(404).json({ message: 'No lectures found for this doctor' });
    }

    res.status(200).json({ message: `Lectures for doctor id: ${doctorId}`, data: lectures });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving lectures by doctor', error: error.message });
  }
};

const getLectureBySubject = async (req, res) =>{
  try {
    const { subjectId } = req.params;
    const lectures = await lecture.findAll({
      where:{
        subject_id : subjectId,
      },
      include:[
        {model: doctor,  as: 'doctor' },
        {model: level,   as: 'level'  },
        {model: section, as: 'section'},
      ],
    });

    if (!lectures.length) {
      return res.status(404).json({ message: 'No lectures found for this subject' });
    }
    res.status(200).json({ message: `Lectures for subject ${subjectId}`, data: lectures });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving lectures by doctor', error: error.message });
  }
};


const getSpecificLecture = async (req, res) => {
  const { lecture_day, lecture_time, lecture_room, lecture_section_id } = req.query;

  const whereConditions = {};

  if (lecture_day) {
    whereConditions.lecture_day = lecture_day; 
  }

  if (lecture_time) {
    whereConditions.lecture_time = lecture_time;
  }

  if (lecture_room) {
    whereConditions.lecture_room = lecture_room;
  }

  if (lecture_section_id) {
    whereConditions.lecture_section_id = lecture_section_id;
  }

  try {
    const lectures = await lecture.findAll({
      where: whereConditions ,
    });

    if (!lectures.length) {
      return res.status(404).json({ message: 'No lectures found for this subject' });
    }
    return res.status(200).json(lectures); 
  } catch (error) {
    console.error('Error fetching lectures:', error);
    return res.status(500).json({ error: 'An error occurred while fetching lectures.' });
  }
};






module.exports = {
  createLecture,
  getLectures,
  getLectureById,
  updateLecture,
  deleteLecture,
  getLecturesBySection,
  getLecturesByLevel,
  getLecturesByDoctor,
  getLectureBySubject,
  getSpecificLecture
};
