const { validationResult } = require('express-validator');
const { lecture, subject, doctor ,section , level , user } = require('../models');
const { sequelize,Sequelize } = require('sequelize');
// const { } = require('../middleware/helperLecture');


const createLecture = async (req, res) => {
  const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
  try {
    const newLecture = await lecture.create(req.body);
    res.status(201).json({
      message: 'Lecture created successfully',
      data: newLecture,
    });
  } catch (error) {
    console.error('Error creating lecture:', error.message);
    res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};


const replaceOne = async (req, res) => {
  try {
    const originalLecture = await lecture.findOne(req.body.originalLectureId);
    if (!originalLecture) {
      throw new Error('Original lecture not found');
    }
    await originalLecture.update(
      { isReplaced: true },
      { fields: ['isReplaced'] } 
    );   

    const replacedLecture = await lecture.create(req.body);

    const lectureStartTime = new Date();
    const [hours, minutes, seconds] = originalLecture.lecture_time.split(':').map(Number);
    lectureStartTime.setHours(hours, minutes, seconds, 0);
    const lectureEndTime = new Date(lectureStartTime.getTime() + originalLecture.lecture_duration * 60000); 
    const remainingTime = lectureEndTime.getTime() - new Date().getTime(); 

    if (remainingTime > 0) {
      setTimeout(async () => {
        try {
          await replacedLecture.destroy();
          await originalLecture.update(
            { isReplaced: false },
            { fields: ['isReplaced'] } 
          );  
          console.log('Original lecture restored successfully.');
        } catch (error) {
          console.error('Failed to restore original lecture:', error);
        }
      }, remainingTime);
    } 

    return res.status(200).json({ message: 'Lecture replaced successfully', replacedLecture });
  } catch (error) {
    console.error('Error during lecture replacement:', error);
    return res.status(500).json({ message: 'Failed to replace lecture', error: error.message });
  }
};



const updateLecture = async (req, res) => {
  const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
  try {
    await lecture.update(req.body,
      {
        where: { id : req.params.id},
        returning: true, 
      }
    );    

    res.status(200).json({
      message: 'Lecture updated successfully',
      // data: await lecture.findOne({where: { id : req.params.id}}),
    });
  } catch (error) {
    console.error('Error creating lecture:', error.message);
    res.status(500).json({ message: 'Internal server error', error: error.message });
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
        const { section_id, level_id, year , term , day } = req.query; 

        const whereClause = {};
        if (section_id) whereClause.lecture_section_id = section_id;
        if (level_id) whereClause.lecture_level_id = level_id;
        if (year) whereClause.year = year;
        if (term) whereClause.Term = term;
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
            const term = lec.term; 
            const day = lec.lecture_day; 
          

            if (!organizedLectures[term]) {
                organizedLectures[term] = {};
            }

            if (!organizedLectures[term][day]) {
                organizedLectures[term][day] = [];
            }

            organizedLectures[term][day].push({
                id: lec.id,
                subject_name: lec.subject.subject_name, 
                startTime: lec.lecture_time, 
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

// To get lectures for a specific doctor
const getDoctorLectures = async (req, res) => {
  try {
    const doctorId = req.user.user_id; 

    const lectures = await lecture.findAll({
      where: { doctor_id: doctorId }, 
      include: [
        { model: subject, as: 'subject', attributes: ['subject_name'] },
        { model: section, as: 'section', attributes: ['section_name'] },
        { model: level, as: 'level', attributes: ['level_name'] },
      ],
    });

    if (!lectures.length) {
      return res.status(404).json({ message: 'No lectures found for this doctor' });
    }

    const organizedLectures = {};
    lectures.forEach((lec) => {
      const term = lec.term;
      const day = lec.lecture_day;

      if (!organizedLectures[term]) {
        organizedLectures[term] = {};
      }
      if (!organizedLectures[term][day]) {
        organizedLectures[term][day] = [];
      }

      organizedLectures[term][day].push({
        id: lec.id,
        subject_name: lec.subject.subject_name,
        startTime: lec.lecture_time,
        duration: lec.lecture_duration,
        lecture_room: lec.lecture_room,
      });
    });

    res.status(200).json({
      message: 'Lectures retrieved successfully',
      data: organizedLectures,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving lectures', error: error.message });
  }
};

module.exports = {
  createLecture,
  getLectures,
  updateLecture,
  deleteLecture,
  getLecturesGroupedByCriteria,
  getLectureYear,
  getDoctorLectures,
  replaceOne
};