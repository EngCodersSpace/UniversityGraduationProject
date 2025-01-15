const {subject,doctor,user,study_plan_elment}=require('../models');
const { validationResult } = require('express-validator');
const {  translateText } = require('../middleware/translationServices');


exports.createSubject=async (req, res) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
          return res.status(400).json({ errors: errors.array() });
        }
        const {} = req.body;

        const targetLanguage = req.body.language === 'en'?'ar':'en';
        const translatedName = await translateText(req.body.subject_name, req.body.language, targetLanguage);
        const translatedDesc = await translateText(req.body.subject_description, req.body.language, targetLanguage);

        const newSubject = await subject.create({
          subject_id: req.body.subject_id,
          subject_name:{
            [req.body.language] : req.body.subject_name,
            [targetLanguage] : translatedName
          },
          number_of_units:req.body.number_of_units,
          subject_description:{
            [req.body.language] : req.body.subject_description,
            [targetLanguage] : translatedDesc
          }
        });
    
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
        const Subjects = await subject.findAll({
          include: [{
            model: doctor,
            attributes: ['doctor_id'],
            through:{ attributes: [] },
            include:[{
              model:user,
              as:'user',
              attributes: ['user_name'],
            }]
          }],
        });

        res.status(200).json({message:'getAllLectures', data: Subjects });
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error retrieving Subjects', error: error.message });
      }
};

exports.getSubjectByfilter = async (req,res) => {

  try {
    const { section_id, level_id } = req.query;
    const whereClause = {};
    if (section_id) whereClause.section_id = section_id;
    if (level_id) whereClause.level_id = level_id;

    const Subjects= await study_plan_elment.findAll({
      where:whereClause,
      attributes: [],
      include: [
        {
          model:subject,
          attributes: ['subject_id', 'subject_name','number_of_units'],
        },
      ],
    });
    
    if (!Subjects || Subjects.length === 0) {
      return res
        .status(404)
        .json({ message: "No Subjects found for the specified criteria" });
    }
    return res.status(200).json({message:'Bring All Subjects after fltering ', SubjectbyFilter:Subjects});
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving Subjects', error: error.message });
  }
};

exports.updateSubject = async (req, res) => {
    try {
      const { id } = req.query;
      const {} = req.body;

      if (!id) {
        return res.status(400).json({ message: 'Subject ID is required' });
      }

      const targetLanguage = req.body.language === 'en'?'ar':'en';
      const translatedName = await translateText(req.body.subject_name, req.body.language, targetLanguage);
      const translatedDesc = await translateText(req.body.subject_description, req.body.language, targetLanguage);

      const updateSubject = await subject.update({
        subject_id: req.body.subject_id,
          subject_name:{
            [req.body.language] : req.body.subject_name,
            [targetLanguage] : translatedName
          },
          number_of_units:req.body.number_of_units,
          subject_description:{
            [req.body.language] : req.body.subject_description,
            [targetLanguage] : translatedDesc
          }
      }, {
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
        const deleted = await subject.destroy({
          where: { subject_id: req.query.id }
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
