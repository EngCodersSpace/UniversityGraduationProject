
   
const {study_plan}=require('../models');
const { validationResult } = require('express-validator');


exports.createStudyPlan=async (req, res) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
          return res.status(400).json({ errors: errors.array() });
        }
        const {} = req.body;
    
        const newStudyPlan = await study_plan.create(req.body);
    
        res.status(201).json({
          message: 'Study Plan created successfully',
          data: newStudyPlan,
        });
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error creating StudyPlan', error: error.message });
      }
};

exports.getStudyPlanById=async (req, res) => {
    const { id } = req.query;

    try {
        const StudyPlan = await study_plan.findOne({
            where: { study_plan_id: id }, 
        });

        if (!StudyPlan) {
            return res.status(404).json({ message: 'StudyPlan not found' });
        }

        res.status(200).json({
            message: 'StudyPlan found',
            data: StudyPlan,
        });
    } catch (error) {
        console.error('Error fetching StudyPlan by ID:', error.message);
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

exports.getAllStudyPlan=async (req, res) => {
    try {
        const StudyPlan = await study_plan.findAll();
        res.status(200).json({message:'getAllLectures', data: StudyPlan });
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error retrieving StudyPlan', error: error.message });
      }
};

exports.updateStudyPlan = async (req, res) => {
    try {
      const { id } = req.query;
      const {} = req.body;

      const updateStudyPlan = await study_plan.update(req.body, {
        where: { study_plan_id : id },
        returning: true,
      });
  
      if (updateStudyPlan[0] === 0) {
        return res.status(404).json({ message: 'Subject not found' });
      }
  
      res.status(200).json({
        message: 'StudyPlan updated successfully',
        data: updateStudyPlan[1][0],
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error updating StudyPlan', error: error.message });
    }
};

exports.deleteStudyPlan=async (req, res) => {
    try {
        const { id } = req.query;
    
        const deleted = await study_plan.destroy({
          where: { study_plan_id: id },
        });
    
        if (deleted === 0) {
          return res.status(404).json({ message: 'study plan not found' });
        }
    
        res.status(200).json({
          message: 'study plan deleted successfully',
        });
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error deleting StudyPlan', error: error.message });
      }
};



