
const {subject, section , level  } = require('../models'); 


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

module.exports = { getAllData };