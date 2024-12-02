   
const {subject,study_plan_elment,grade,prerequisite,exam, document }=require('../models');
const { validationResult } = require('express-validator');




exports.createSubject=async (req, res) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
          return res.status(400).json({ errors: errors.array() });
        }
        const {} = req.body;
    
        const newSubject = await subject.create(req.body);
    
        res.status(201).json({
          message: 'Subject created successfully',
          data: newSubject,
        });
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error creating Subject', error: error.message });
      }
};

exports.getSubjectById=async (req, res) => {
    const { id } = req.query;

    try {
        const Subject = await subject.findOne({
            where: { subject_id: id }, 
            // include: [
                
            // ],
        });

        if (!Subject) {
            return res.status(404).json({ message: 'Subject not found' });
        }

        res.status(200).json({
            message: 'Subject found',
            data: Subject,
        });
    } catch (error) {
        console.error('Error fetching Subject by ID:', error.message);
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

exports.getAllSubject=async (req, res) => {
    try {
        const Subjects = await subject.findAll();
        res.status(200).json({message:'getAllLectures', data: Subjects });
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error retrieving Subjects', error: error.message });
      }
};

exports.updateSubject = async (req, res) => {
    try {
      const { id } = req.query;
      const {} = req.body;

      const updateSubject = await subject.update(req.body, {
        where: { subject_id : id },
        returning: true,
      });
  
      if (updateSubject[0] === 0) {
        return res.status(404).json({ message: 'Subject not found' });
      }
  
      res.status(200).json({
        message: 'Subject updated successfully',
        data: updateSubject[1][0],
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error updating Subject', error: error.message });
    }
};

exports.deleteSubject=async (req, res) => {
    try {
        const { id } = req.query;
    
        const deleted = await subject.destroy({
          where: { subject_id: id },
        });
    
        if (deleted === 0) {
          return res.status(404).json({ message: 'Subject not found' });
        }
    
        res.status(200).json({
          message: 'Subject deleted successfully',
        });
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error deleting Subject', error: error.message });
      }
};



