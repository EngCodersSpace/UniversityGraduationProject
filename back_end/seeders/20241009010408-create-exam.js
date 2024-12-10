'use strict';

const { faker } = require('@faker-js/faker');
const { exam, subject ,section,level} = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const subjects = await subject.findAll();
    const levels =await level.findAll();
    const sections =await section.findAll();

    
    const exams = [];
    for (let i = 0; i < Math.min(subjects.length, 10); i++) { 
      exams.push({
        subject_id: subjects[i].subject_id, 
        exam_section_id: sections[i % sections.length].id,
        exam_level_id:  levels[i % levels.length].id,
        exam_term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        exam_year: faker.date.past(2).getFullYear(), 
        exam_date: faker.date.future(1).toISOString().split('T')[0], 
        exam_time: faker.date.future(1).toISOString().split('T')[1].slice(0, 8), 
        exam_day: faker.helpers.arrayElement(['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday']),
        exam_room: faker.string.alphanumeric(10), 
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    
    await exam.bulkCreate(exams);
  },

  down: async (queryInterface, Sequelize) => {
    
    await queryInterface.bulkDelete('exams', null, {});
  }
};
