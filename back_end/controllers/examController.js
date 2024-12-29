const { exam, subject , section,level } = require('../models'); 
const { validationResult } = require('express-validator'); 
const { Sequelize} = require('sequelize');

//  All Functions are perfict right now 2024-12-10
exports.createExam = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
        const newExam = await exam.create(req.body,{
            include: [{ model: subject, as: 'subject' }], 
        });
        res.status(201).json({
            message: 'Exam created successfully',
            exam: newExam,
        });
    } catch (error) {
        console.error('Error creating exam:', error.message);
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

exports.getExam = async (req, res) => {
    try {
      const examData = await exam.findOne({
        where: { exam_id: req.query.exam_id},
        include: [
            { model: subject, as: 'subject' },
            { model: section, as: 'section'},
            { model: level ,  as: 'level'}
        ], 
      });
      if (!examData || !examData.subject) {
        return res.status(404).json({ message: 'Exam not found' });
      }
      res.status(200).json({ message: `This is Exam of ${req.query.exam_id} ID`, Exam :examData});
    } catch (err) {
      res.status(500).json({ message: 'Error fetching exam', error: err.message });
    }
};
  
exports.getAllExams = async (req, res) => {
    try {
      const exams = await exam.findAll({
        include: [
            { model: subject, as: 'subject' },
            { model: section, as: 'section'},
            { model: level ,  as: 'level'}
        ], 
      });
  
      res.status(200).json({ message: 'These are Exams', Exams : exams});
    } catch (err) {
      res.status(500).json({ message: 'Error fetching exams', error: err.message });
    }
};

exports.getExamGroupedByCriteria = async (req, res) => {
    try {
        const whereClause = {};
        if (req.query.section_id) whereClause.exam_section_id = req.query.section_id;
        if (req.query.level_id) whereClause.exam_level_id = req.query.level_id;

        const Exam = await exam.findAll({
            where: whereClause,
            include: [
                { model: subject, as: 'subject' },
                { model: section, as: 'section' },
                { model: level, as: 'level' },
            ],
        });

        if (!Exam.length) {
            return res.status(404).json({ message: 'No Exams found for the specified criteria' });
        }

        const organizedLectures = [];
        
        Exam.forEach(lec => { 
            organizedLectures.push({
                exam_id: lec.exam_id,
                subject_id: lec.subject_id, 
                exam_date:lec.exam_date,
                exam_day:lec.exam_day,
                exam_time : lec.exam_time, 
                exam_room: lec.exam_room, 
            });
        });

        res.status(200).json({ message: 'Exams retrieved successfully', data: organizedLectures });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error retrieving Exams', error: error.message });
    }
};

exports.getExamYear = async (req, res) => {
    try {
      const uniqueYears = await exam.findAll({
        attributes: [
          [Sequelize.fn('DISTINCT', Sequelize.col('exam_year')), 'year']
        ],
        raw: true
      });
  
      if (uniqueYears.length === 0) {
        return res.status(404).json({ message: 'No unique years found in the Exam table' });
      }
  
      const years = uniqueYears.map(item => item.year);
  
      res.status(200).json({ message: 'Unique years retrieved successfully', data: years });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error retrieving unique years', error: error.message });
    }
};

exports.updateExam = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {   
        await exam.update(req.body, {
            where: { exam_id: req.query.exam_id },
        });

        const updatedExam = await exam.findOne({
            where: { exam_id: req.query.exam_id },
            include: [{ model: subject, as: 'subject' }], 
        });

        res.status(200).json({
            message: 'Exam updated successfully',
            exam: updatedExam,
        });
    } catch (error) {
        console.error('Error updating exam:', error.message);
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

exports.deleteExam = async (req, res) => {
    try {
        const foundExam = await exam.destroy({
            where: { exam_id: req.query.exam_id },
        });

        if (!foundExam) {
            return res.status(404).json({ message: 'Exam not found' });
        }
        res.status(200).json({
            message: 'Exam deleted successfully',
        });
    } catch (error) {
        console.error('Error deleting exam:', error.message);
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};