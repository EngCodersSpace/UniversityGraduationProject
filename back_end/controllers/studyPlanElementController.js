const { study_plan_elment, study_plan, subject, doctor,section,level } = require('../models'); 
const { validationResult } = require('express-validator');
const { Sequelize} = require('sequelize');
const { Op } = require("sequelize");

// when you Create a new study plan element befor see the (study plan id,subject id , doctor id )
exports.createStudyPlanElement = async (req, res) => {
    try {
    const newStudyPlanElement = await study_plan_elment.create(req.body,{
      include: [
        { model: study_plan, as: 'study_plan' },
        { model: subject, as: 'subject' },
        { model: doctor, as: 'doctor' },
        { model: section, as: 'section' },
        { model: level, as: 'level' },
      ]
    });
    
    res.status(201).json({
      message: 'Study Plan Element created successfully',
      data: newStudyPlanElement
    });
  } catch (err) {
    res.status(500).json({ message: 'Error creating study plan element', error: err.message });
  }
};

// Get a single study plan element by ID with its associated data
exports.getStudyPlanElement = async (req, res) => {
    try {  
      const studyPlanElement = await study_plan_elment.findOne({
        where: { id: req.query.id },
        include: [
          { model: study_plan, as: 'study_plan' },
          { model: subject, as: 'subject' },
          { model: doctor, as: 'doctor' },
          { model: section, as: 'section' },
          { model: level, as: 'level' },
          // { model: prerequisite, as: 'prerequisites' } 
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
  
exports.getAllStudyPlanElement = async (req, res) => {
  try {  
    const studyPlanElements = await study_plan_elment.findAll({
      include: [
        { model: study_plan, as: 'study_plan' },
        { model: subject, as: 'subject' },
        { model: doctor, as: 'doctor' },
        { model: section, as: 'section' },
        { model: level, as: 'level' },
        // { model: prerequisite, as: 'prerequisites' } 
      ]
    });

    if (!studyPlanElements) {
      return res.status(404).json({ message: 'Study Plan Element not found' });
    }

    res.status(200).json({message:'Get All study Plan Elements Successfully',data:studyPlanElements});
  } catch (err) {
    res.status(500).json({ message: 'Error fetching study plan element', error: err.message });
  }
};

// Update an existing study plan element
exports.updateStudyPlanElement = async (req, res) => {
    try {
      const { id } = req.query; // ID passed from the URL
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
      const { id } = req.query; // ID passed from the URL
  
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

exports.getStudyPlanElementPanel = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = ["study_plan_elment_id", "study_plan_id", "subject_id", "doctor_id", "section_id",
    "level_id","number_of_units","term",
  ];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      section_id,
      level_id,
      subject_id,
      study_plan_id,
      doctor_id,
      number_of_units,
      term,
      page = 1,
      limit = 10,
      orderBy = "study_plan_elment_id",
      sort = "ASC",
    } = req.query;


    const pageNumber = parseInt(page, 10);
    let limitNumber = parseInt(limit, 10);

    const LOWER_LIMIT = 10;
    const UPPER_LIMIT = 250;
    if (isNaN(limitNumber) || limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
    if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;

    const offset = (pageNumber - 1) * limitNumber;

    const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy) ? orderBy : "study_plan_elment_id";
    const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase()) ? sort.toUpperCase() : "ASC";

   

    const { count, rows: Elements } = await study_plan_elment.findAndCountAll({
      where: {
        ...(number_of_units && {
          number_of_units: number_of_units  
        }),
        ...(term && {
          term: term  
        }),

      }, 
      include: [
        { model: section, as: "section", required: true, 
          where: {
          ...(section_id && { id: section_id}),
          }
        },
        { model: level, as: "level", required: true, 
          where: {
          ...(level_id && { id: level_id}),
          }
        },
        { model: subject, as: "subject", required: true, 
          where: {
          ...(subject_id && { subject_id: subject_id}),
          }
        },
        { model: study_plan, as: "study_plan", required: true, 
          where: {
          ...(study_plan_id && { study_plan_id: study_plan_id}),
          }
        },
        { model: doctor, as: "doctor", required: true, 
          where: {
          ...(doctor_id && { doctor_id: doctor_id}),
          }
        },



      ],
      distinct: true,
      limit: limitNumber,
      offset: offset,
      order: [[validOrderBy, validSort]],
    });

    if (!Elements.length) {
      return res.status(404).json({ message: "No Elements found for the specified criteria" });
    }


    res.status(200).json({
      message: "Elements retrieved successfully",
      data: Elements,
      pagination: {
        total: count,
        totalPages: Math.ceil(count / limitNumber),
        currentPage: pageNumber,
        perPage: limitNumber,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error retrieving exams", error: error.message });
  }
};
