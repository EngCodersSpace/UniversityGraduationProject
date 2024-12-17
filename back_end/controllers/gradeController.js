
const { user,subject, grade ,student,section,level } = require('../models'); 
const { validationResult } = require('express-validator');
const { Sequelize} = require('sequelize');
const jwt = require("jsonwebtoken");
const SECRET_KEY = process.env.SECRET_KEY;

exports.createGrade = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
      const { } = req.body;
  
      const studentExists = await student.findOne({ where: {student_id:req.body.student_id}});
      if (!studentExists) {
        return res.status(404).json({ message: 'Student not found' });
      }
  
      const subjectExists = await subject.findOne({where:{subject_id:req.body.subject_id}});
      if (!subjectExists) {
        return res.status(404).json({ message: 'Subject not found' });
      }
  
      const newGrade = await grade.create(req.body);
  
      res.status(201).json({
        message: 'Grade created successfully',
        grade: newGrade,
      });
    } catch (error) {
      console.error('Error creating grade:', error.message);
      res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};



// get All Grades For specific =>  student_id  and  level_id and Term 
exports.getGrades = async (req, res) => {
  try {
      const { id , levelID , Term} = req.query; 

      if (!id) {
          return res.status(400).json({ message: "Student ID is required" });
      }

      // Use a condition for levelID to prevent errors if it's not supplied
      const grades = await grade.findAll({
          where: { student_id: id , level_id:levelID ,term:Term}, 
          // include: [
          //     { model: student, as: 'student' },
          //     { model: subject, as: 'subject' },
          //     { model: section, as: 'section' }
          // ],
      });

      if (!grades.length) {
          return res.status(404).json({ message: 'No grades found for this student' });
      }

      res.status(200).json({ message: 'These your grades', Grades: grades });
  } catch (error) {
      console.error('Error fetching grades:', error.message);
      res.status(500).json({ message: 'Internal server error', error: error.message });
  }
}; 

exports.getAllGrades = async (req, res) => {
  try {
    
      // Use a condition for levelID to prevent errors if it's not supplied
      const grades = await grade.findAll();

      if (!grades.length) {
          return res.status(404).json({ message: 'No grades found ' });
      }

      res.status(200).json({ message: 'These all grades', Grades: grades });
  } catch (error) {
      console.error('Error fetching grades:', error.message);
      res.status(500).json({ message: 'Internal server error', error: error.message });
  }
}; 

//   additional function i will deleted if it is unneccessary 
exports.getGradeById = async (req, res) => {
    try {
      const { id } = req.params;
  
      const gradeDetails = await grade.findOne({
        where: { grad_id: id },
        include: [
          { model: student, as: 'student' },
          { model: subject, as: 'subject' },
          { model: section, as: 'section'}
        ],
      });
  
      if (!gradeDetails) {
        return res.status(404).json({ message: 'Grade not found' });
      }
  
      res.status(200).json({ message: `This is  degree of ${id} ID `, grade: gradeDetails });
    } catch (error) {
      console.error('Error fetching grade:', error.message);
      res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

// To get All year_issue DISTINCT (without duplicate)
exports.getGradeYear = async (req, res) => {
  try {
    const uniqueYears = await grade.findAll({
      attributes: [
        [Sequelize.fn('DISTINCT', Sequelize.col('year_of_issue')), 'year']
      ],
      raw: true
    });

    if (uniqueYears.length === 0) {
      return res.status(404).json({ message: 'No unique years found in the Grade table' });
    }

    const years = uniqueYears.map(item => item.year);

    res.status(200).json({ message: 'Unique years retrieved successfully', data: years });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving unique years', error: error.message });
  }
};

//  To get section of current logged user 
exports.getSectionOfCurrentUser = (req, res) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) {
    return res.status(401).json({ message: "Access token is missing" });
  }

  jwt.verify(token, SECRET_KEY, async (err, decoded) => {
    if (err) {
      return res.status(403).json({ message: "Invalid token" });
    }

    try {
      const foundUser = await user.findOne({
        where: { user_id: decoded.user_id },
        include: [
          { model: student, as: "student" },
          { model: section, as: "section" },
        ],
      });

      if (!foundUser) {
        return res.status(404).json({ message: "User not found" });
      }
      res.json({
        message: "me",
        section: foundUser.user_section_id
      });
    } catch (error) {
      console.error("Error fetching user:", error.message);
      res.status(500).json({ message: "Internal server error", error: error.message });
    }
  });
};













exports.updateGrade = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
      const { id } = req.params;
      const {
        student_id,
        subject_id,
        exam_grade,
        work_grade,
        term,
        section,
        level,
        year_of_issue,
        is_absent,
        status,
      } = req.body;
  
      const gradeToUpdate = await grade.findOne({ where: { grad_id: id } });
  
      if (!gradeToUpdate) {
        return res.status(404).json({ message: 'Grade not found' });
      }
  
      // Check if student_id or subject_id are provided and validate them
      if (student_id) {
        const studentExists = await student.findByPk(student_id);
        if (!studentExists) {
          return res.status(404).json({ message: 'Student not found' });
        }
      }
  
      if (subject_id) {
        const subjectExists = await subject.findByPk(subject_id);
        if (!subjectExists) {
          return res.status(404).json({ message: 'Subject not found' });
        }
      }
  
      await gradeToUpdate.update({
        student_id,
        subject_id,
        exam_grade,
        work_grade,
        term,
        section,
        level,
        year_of_issue,
        is_absent,
        status,
      });
  
      res.status(200).json({
        message: 'Grade updated successfully',
        grade: gradeToUpdate,
      });
    } catch (error) {
      console.error('Error updating grade:', error.message);
      res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

exports.deleteGrade = async (req, res) => {
    try {
      const { id } = req.params;
  
      const gradeToDelete = await grade.findOne({ where: { grad_id: id } });
  
      if (!gradeToDelete) {
        return res.status(404).json({ message: 'Grade not found' });
      }
  
      await gradeToDelete.destroy();
  
      res.status(200).json({ message: 'Grade deleted successfully' });
    } catch (error) {
      console.error('Error deleting grade:', error.message);
      res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};



