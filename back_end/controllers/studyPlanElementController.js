const { study_plan_elment, study_plan, subject, doctor, prerequisite } = require('../models'); 
const { validationResult } = require('express-validator');


// when you Create a new study plan element befor see the (study plan id,subject id , doctor id )
exports.createStudyPlanElement = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    try {
    const { study_plan_id, subject_id, doctor_id, section, level, number_of_units, term } = req.body;

    const newStudyPlanElement = await study_plan_elment.create({
      study_plan_id,
      subject_id,
      doctor_id,
      section,
      level,
      number_of_units,
      term
    });

    res.status(201).json({
      message: 'Study Plan Element created successfully',
      study_plan_elment: newStudyPlanElement
    });
  } catch (err) {
    res.status(500).json({ message: 'Error creating study plan element', error: err.message });
  }
};

// Get a single study plan element by ID with its associated data
exports.getStudyPlanElement = async (req, res) => {
    try {
      const { id } = req.params; // ID passed from the URL
  
      const studyPlanElement = await study_plan_elment.findOne({
        where: { study_plan_elment_id: id },
        include: [
          { model: study_plan, as: 'study_plan' },
          { model: subject, as: 'subject' },
          { model: doctor, as: 'doctor' },
          { model: prerequisite, as: 'prerequisites' } // Include prerequisites associated with this study plan element
        ]
      });
  
      if (!studyPlanElement) {
        return res.status(404).json({ message: 'Study Plan Element not found' });
      }
  
      res.status(200).json(studyPlanElement);
    } catch (err) {
      res.status(500).json({ message: 'Error fetching study plan element', error: err.message });
    }
};
  

// Update an existing study plan element
exports.updateStudyPlanElement = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    
    try {
      const { id } = req.params; // ID passed from the URL
      const { study_plan_id, subject_id, doctor_id, section, level, number_of_units, term } = req.body;
  
      const studyPlanElement = await study_plan_elment.findOne({ where: { study_plan_elment_id: id } });
  
      if (!studyPlanElement) {
        return res.status(404).json({ message: 'Study Plan Element not found' });
      }
  
      // Update the study plan element
      studyPlanElement.study_plan_id = study_plan_id || studyPlanElement.study_plan_id;
      studyPlanElement.subject_id = subject_id || studyPlanElement.subject_id;
      studyPlanElement.doctor_id = doctor_id || studyPlanElement.doctor_id;
      studyPlanElement.section = section || studyPlanElement.section;
      studyPlanElement.level = level || studyPlanElement.level;
      studyPlanElement.number_of_units = number_of_units || studyPlanElement.number_of_units;
      studyPlanElement.term = term || studyPlanElement.term;
  
      await studyPlanElement.save();
  
      res.status(200).json({
        message: 'Study Plan Element updated successfully',
        study_plan_elment: studyPlanElement
      });
    } catch (err) {
      res.status(500).json({ message: 'Error updating study plan element', error: err.message });
    }
};
  

// Delete a study plan element
exports.deleteStudyPlanElement = async (req, res) => {
    try {
      const { id } = req.params; // ID passed from the URL
  
      const studyPlanElement = await study_plan_elment.findOne({ where: { study_plan_elment_id: id } });
  
      if (!studyPlanElement) {
        return res.status(404).json({ message: 'Study Plan Element not found' });
      }
  
      await studyPlanElement.destroy();
  
      res.status(200).json({ message: 'Study Plan Element deleted successfully' });
    } catch (err) {
      res.status(500).json({ message: 'Error deleting study plan element', error: err.message });
    }
  
};
  

  




