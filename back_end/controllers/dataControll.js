const {subject, section , level ,study_plan_elment,user ,doctor,student} = require('../models'); 
const getAllData = async (req, res) => {
    try {
      const [subjects, sections, levels] = await Promise.all([
         subject.findAll({
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
        }),
        section.findAll(),
        level.findAll()
      ]);
  
      res.status(200).json({
        message: 'getAllData',
        data: {
          subjects: subjects,
          sections: sections,
          levels: levels
        }
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error retrieving data', error: error.message });
    }
};

const getSubjects= async (req,res)=>{
  try {
    const{section_id,level_id,study_plan_id}=req.query;
    const whereClause = {};
    if (section_id)    whereClause.section_id    = section_id;
    if (level_id)      whereClause.level_id      = level_id;
    if (study_plan_id) whereClause.study_plan_id = study_plan_id;

    const Subjects = await study_plan_elment.findAll({
        where: whereClause,
        include: [
            { model: subject,
              as: 'subject' ,
              // attributes: [
              //   ['subject_name']
              // ],
            },
            { model: section, as: 'section' },
            { model: level,   as: 'level'   },
        ],
    });
    
    if (!Subjects.length) {
      return res.status(404).json({ message: 'Subjects not found' });
    }

    res.status(200).json({
      message: 'get All Subjects For specific section and level',
      data: {
        subjects: Subjects,
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving data', error: error.message });
  }
};

const getAllSubjects = async (req, res) => {
  try {
      const subjects = await subject.findAll();
      res.status(200).json({
          message: 'getAllSubjects',
          data: {
              subjects: subjects
          }
      });
  } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error retrieving subjects', error: error.message });
  }
};

const getAllSections = async (req, res) => {
  try {
      const sections = await section.findAll();
      res.status(200).json({
          message: 'getAllSections',
          data: {
              sections: sections
          }
      });
  } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error retrieving sections', error: error.message });
  }
};

const getAllLevels = async (req, res) => {
  try {
      const levels = await level.findAll();
      res.status(200).json({
          message: 'getAllLevels',
          data: {
              levels: levels
          }
      });
  } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error retrieving levels', error: error.message });
  }
};

const getAllUsers = async (req, res) => {
  try {
      const Users = await user.findAll();
      res.status(200).json({
          message: 'getAllUsers',
          data: {
            users: Users
          }
      });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving Users', error: error.message });
  }
};

const getAllDoctors = async (req, res) => {
  try {
      const Doctors = await doctor.findAll();
      res.status(200).json({
          message: 'getAllDoctor',
          data: {
            doctors: Doctors
          }
      });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving Doctors', error: error.message });
  }
};

const getAllStudents = async (req, res) => {
  try {
      const Students = await student.findAll();
      res.status(200).json({
          message: 'getAllDoctor',
          data: {
            students: Students
          }
      });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving Students', error: error.message });
  }
};

module.exports = { 
  getAllData,
  getSubjects,
  getAllSubjects,
  getAllSections,
  getAllLevels,
  getAllUsers,
  getAllDoctors,
  getAllStudents
};