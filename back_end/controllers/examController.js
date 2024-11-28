

const { exam, subject } = require('../models'); 
const { validationResult } = require('express-validator'); 


// when you create an Exam first see  (subjects IDs) must be the same  
exports.createExam = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const {
        subject_id,
        exam_section,
        exam_level,
        exam_term,
        exam_year,
        exam_date,
        exam_time,
        exam_day,
        exam_room,
    } = req.body;

    try {
        const existingSubject = await subject.findOne({ where: { subject_id } });
        if (!existingSubject) {
            return res.status(404).json({ message: 'Subject not found' });
        }

        const newExam = await exam.create(
            {
                subject_id, // Reference to the subject
                exam_section,
                exam_level,
                exam_term,
                exam_year,
                exam_date,
                exam_time,
                exam_day,
                exam_room,
            },
            {
                include: [{ model: subject }], 
            }
        );

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
      const { id : exam_id } = req.params;
      const examData = await exam.findOne({
        where: { exam_id },
        include: [{ model: subject, as: 'subject' }], 
      });
      if (!examData || !examData.subject) {
        return res.status(404).json({ message: 'Exam not found' });
      }
      res.status(200).json(examData);
    } catch (err) {
      res.status(500).json({ message: 'Error fetching exam', error: err.message });
    }
};
  
exports.getAllExams = async (req, res) => {
    try {
      const exams = await exam.findAll({
        include: [{ model: subject, as: 'subject' }], 
      });
  
      res.status(200).json(exams);
    } catch (err) {
      res.status(500).json({ message: 'Error fetching exams', error: err.message });
    }
};
  
exports.updateExam = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    const { id: exam_id } = req.params;
    const {
        subject_id,
        exam_section,
        exam_level,
        exam_term,
        exam_year,
        exam_date,
        exam_time,
        exam_day,
        exam_room,
    } = req.body;

    try {
        // Find the exam by ID, including the associated subject
        const foundExam = await exam.findOne({
            where: { exam_id },
            include: [{ model: subject }],
        });

        // Check if the exam exists
        if (!foundExam) {
            return res.status(404).json({ message: 'Exam not found' });
        }

        // Check if the new subject_id exists in the database
        const foundSubject = await subject.findOne({
            where: { subject_id },
        });

        if (!foundSubject) {
            return res.status(404).json({ message: 'Subject not found' });
        }

        // Update the exam data
        await foundExam.update({
            subject_id, // Update subject_id if changed
            exam_section,
            exam_level,
            exam_term,
            exam_year,
            exam_date,
            exam_time,
            exam_day,
            exam_room,
        });

        // Respond with the updated exam
        res.status(200).json({
            message: 'Exam updated successfully',
            exam: foundExam,
        });
    } catch (error) {
        console.error('Error updating exam:', error.message);
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

exports.deleteExam = async (req, res) => {
    const { id: exam_id } = req.params;

    try {
        // Find the exam by ID, including the associated subject
        const foundExam = await exam.findOne({
            where: { exam_id },
            include: [{ model: subject }],
        });

        // Check if the exam exists
        if (!foundExam) {
            return res.status(404).json({ message: 'Exam not found' });
        }

        // Delete the exam (optional: you can delete associated subject if needed)
        await foundExam.destroy();

        res.status(200).json({
            message: 'Exam deleted successfully',
        });
    } catch (error) {
        console.error('Error deleting exam:', error.message);
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};








