const { exam, subject , section,level } = require('../models'); 
const { upsertRefreshState} = require('../controllers/refreshController');

const { Sequelize} = require('sequelize');
const { Op } = require("sequelize");
const {systemRefresh} = require('../middleware/notificationMiddleware');


//  All Functions are perfict right now 2024-12-10
exports.createExam = async (req, res) => {
    try {

        const newExam = await exam.create(req.body,{
            include: [{ model: subject, as: 'subject' }], 
        });

        await upsertRefreshState("exam", {
          section_id: req.body.exam_section_id , 
          level_id: req.body.exam_level_id       
        });

        // await systemRefresh({ 
        //   entity: 'exam',
        //   targetType: 'section_level', 
        //   sectionId: req.body.exam_section_id, 
        //   levelId: req.body.exam_level_id,     
        //   action: 'create'
        // }).catch(err => {
        //   console.error('Refresh notification failed (non-critical):', err);
        // });

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

exports.getExamGroupedByCriteriaPanel = async (req, res) => {
    const ALLOWED_ORDER_FIELDS = ["exam_date", "exam_time", "exam_day", "exam_room", "subject_id"];
    const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];
  
    try {
      const {
        section_id,
        level_id,
        subject_id,
        exam_date,
        exam_day,
        exam_time,
        exam_room,
        page = 1,
        limit = 10,
        orderBy = "exam_date",
        sort = "ASC",
        search,
      } = req.query;
  
  
      const pageNumber = parseInt(page, 10);
      let limitNumber = parseInt(limit, 10);
  
      const LOWER_LIMIT = 10;
      const UPPER_LIMIT = 250;
      if (isNaN(limitNumber) || limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
      if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;
  
      const offset = (pageNumber - 1) * limitNumber;
  
      const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy) ? orderBy : "exam_date";
      const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase()) ? sort.toUpperCase() : "ASC";
  
     
  
      const { count, rows: exams } = await exam.findAndCountAll({
        where: {
          ...(exam_room && {
            exam_room: exam_room  
          }),
          ...(exam_date && {
            exam_date: exam_date  
          }),
          ...(exam_time && {
            exam_time: exam_time  
          }),
          ...(exam_day && {
            exam_day: exam_day  
          }),
          ...(subject_id && {
            subject_id: subject_id  
          }),

          ...(search &&{
            [Op.or]: [
              { exam_room: { [Op.like]: `%${search}%` } },
              { exam_time: { [Op.like]: `%${search}%` } },
              { exam_day: { [Op.like]: `%${search}%` } },
              { subject_id: { [Op.like]: `%${search}%` } }, 
            ],
          }),
        },
        include: [
          { model: subject, as: "subject" },
          { model: section,
            as: "section",
            required: true, 
            where: {
            ...(section_id && {
              id: section_id
            }),
          }
          },
          { model: level, as: "level",
            required: true, 
            where: {
            ...(level_id && {
              id: level_id
            }),
          }
          },
        ],
        distinct: true,
        limit: limitNumber,
        offset: offset,
        order: [[validOrderBy, validSort]],
      });
  
      if (!exams.length) {
        return res.status(404).json({ message: "No exams found for the specified criteria" });
      }
  
  
      res.status(200).json({
        message: "Exams retrieved successfully",
        data: exams,
        pagination: {
          totalExams: count,
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
    try {   
        await exam.update(req.body, {
            where: { exam_id: req.query.exam_id },
        });

        const updatedExam = await exam.findOne({
            where: { exam_id: req.query.exam_id },
            include: [{ model: subject, as: 'subject' }], 
        });

        await upsertRefreshState("exam",`section_id : ${req.body.exam_section_id} - level_id : ${req.body.exam_level_id}`);


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
        const foundExam = await exam.findByPk(req.query.exam_id);

        if (!foundExam) {
            return res.status(404).json({ message: 'Exam not found' });
        }

        await upsertRefreshState("exam", {
          section_id: foundExam.exam_section_id , 
          level_id: foundExam.exam_level_id       
        });



        await foundExam.destroy();
        res.status(200).json({
            message: 'Exam deleted successfully',
        });
    } catch (error) {
        console.error('Error deleting exam:', error.message);
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};
