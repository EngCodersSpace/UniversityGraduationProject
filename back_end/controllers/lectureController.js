const { validationResult } = require('express-validator');
const { lecture, subject, doctor ,section , level , user } = require('../models'); 
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



// To get all lectures
const getLectures = async (req, res) => {
  try {
    const lectures = await lecture.findAll();
    res.status(200).json({message:'getAllLectures', data: lectures });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving lectures', error: error.message });
  }
};

// To get lectures by searching => (section_id, level_id, year , term , day) ||  without searching  
const getLecturesGroupedByCriteria = async (req, res) => {
    try {
        const { section_id, level_id, year , term , day } = req.params; 

        const whereClause = {};
        if (section_id) whereClause.lecture_section_id = section_id;
        if (level_id) whereClause.lecture_level_id = level_id;
        if (year) whereClause.year = year;
        if (term) whereClause.term = term;
        if (day) whereClause.lecture_day = day;


        const lectures = await lecture.findAll({
            where: whereClause,
            include: [
                { model: subject, as: 'subject' },
                { model: doctor,as: 'doctor',
                  include: [
                      {
                          model: user, 
                          as: 'user', 
                          attributes: ['user_name'], 
                      },
                  ],
                },
                { model: section, as: 'section' },
                { model: level, as: 'level' },
            ],
        });

        if (!lectures.length) {
            return res.status(404).json({ message: 'No lectures found for the specified criteria' });
        }

        const organizedLectures = {};
        
        lectures.forEach(lec => {
            const sectionName = lec.section.section_name; 
            const levelName = lec.level.level_name;
            const year = lec.year; 
            const term = lec.term; 
            const day = lec.lecture_day; 
            const time = lec.lecture_time; 

            if (!organizedLectures[term]) {
                organizedLectures[term] = {};
            }

            if (!organizedLectures[term][day]) {
                organizedLectures[term][day] = [];
            }

            organizedLectures[term][day].push({
                id: lec.id,
                title: lec.subject.subject_name, 
                startTime: time, 
                duration: lec.lecture_duration, 
                lecturer: lec.doctor.user.user_name, 
                lecture_room: lec.lecture_room, 
            });
        });

        res.status(200).json({ message: 'Lectures retrieved successfully', data: organizedLectures });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error retrieving lectures', error: error.message });
    }
};

// To get All years in lecture table (without duplicate)
const getLectureYear = async (req, res) => {
  try {
    const uniqueYears = await lecture.findAll({
      attributes: [
        [Sequelize.fn('DISTINCT', Sequelize.col('year')), 'year']
      ],
      raw: true
    });

    if (uniqueYears.length === 0) {
      return res.status(404).json({ message: 'No unique years found in the lecture table' });
    }

    const years = uniqueYears.map(item => item.year);

    res.status(200).json({ message: 'Unique years retrieved successfully', data: years });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving unique years', error: error.message });
  }
};


module.exports = {
  createLecture,
  getLectures,
  updateLecture,
  deleteLecture,
  getLecturesGroupedByCriteria,
  getLectureYear
};
