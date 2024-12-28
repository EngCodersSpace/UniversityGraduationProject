
const {subject, section , level ,study_plan_elment } = require('../models'); 


const getAllData = async (req, res) => {
    try {
      const [subjects, sections, levels] = await Promise.all([
        subject.findAll(),
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

// this function wrote in subjectControll ?
const getAllSubject= async (req,res)=>{
  try {
    const Subjects = await subject.findAll();
    res.status(200).json({
      message: 'get All Subjects',
      data: {
        subjects: Subjects,
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving data', error: error.message });
  }
};

module.exports = { 
  getAllData,
  getSubjects,
  getAllSubject
};