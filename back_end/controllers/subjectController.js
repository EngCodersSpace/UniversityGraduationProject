const {subject,doctor,user,study_plan_elment}=require('../models');
const { validationResult } = require('express-validator');
const {  translateText } = require('../middleware/translationServices');
const { Sequelize,Op } = require("sequelize");


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

exports.getSubjectsByCriteriaPanle = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = ["subject_id", "subject_name", "number_of_units"];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      subject_id,
      subject_name,
      number_of_units,
      page = 1,
      limit = 10,
      orderBy = "subject_id",
      sort = "ASC",
      search,
    } = req.query;

    const lang = req.headers["accept-language"] || "en"; 

    const pageNumber = parseInt(page, 10);
    let limitNumber = parseInt(limit, 10);

    const LOWER_LIMIT = 10;
    const UPPER_LIMIT = 250;
    if (isNaN(limitNumber)) limitNumber = LOWER_LIMIT;
    if (limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
    if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;

    const offset = (pageNumber - 1) * limitNumber;

    const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy) ? orderBy : "subject_id";
    const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase()) ? sort.toUpperCase() : "ASC";

    const { count, rows: subjects } = await subject.findAndCountAll({
      where: {
        ...(subject_id && {
          subject_id:  subject_id  
        }),

        ...(subject_name && {
          subject_name:  { [lang]: subject_name  }
        }),

        ...(number_of_units && {
          number_of_units:  number_of_units  
        }),

    
        ...(search && {
          [Op.or]: [
            Sequelize.where(
              Sequelize.literal(`JSON_UNQUOTE(JSON_EXTRACT(${'subject_id'}, '$.${lang}'))`),
              { [Op.like]: `%${search}%` }
            ),
            Sequelize.where(
              Sequelize.literal(`JSON_UNQUOTE(JSON_EXTRACT(${'subject_name'}, '$.${lang}'))`),
              { [Op.like]: `%${search}%` }
            ),
            // Sequelize.where(
            //   Sequelize.literal(`JSON_UNQUOTE(JSON_EXTRACT(${'number_of_units'}, '$.${lang}'))`),
            //   { [Op.like]: `%${search}%` }
            // ),

          ]
        })
      },
      distinct: true, 
      limit: limitNumber,
      offset: offset,
      order: [[validOrderBy, validSort]],
    });

    if (!subjects.length) {
      return res.status(404).json({ message: "No subjects found for the specified criteria" });
    }

    res.status(200).json({
      message: "Subjects retrieved successfully",
      data: subjects,
      pagination: {
        totalSubjects: count,
        totalPages: Math.ceil(count / limitNumber),
        currentPage: pageNumber,
        perPage: limitNumber,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error retrieving subjects", error: error.message });
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
