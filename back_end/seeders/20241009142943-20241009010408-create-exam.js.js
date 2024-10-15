'use strict';

const { faker } = require('@faker-js/faker');
const { exam, subject } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const subjects = await subject.findAll();

    
    const exams = [];
    for (let i = 0; i < Math.min(subjects.length, 10); i++) { 
      exams.push({
        subject_id: subjects[i].subject_id, 
        exam_section: faker.helpers.arrayElement(['Computer', 'Communications', 'Civil', 'Architecture']),
        exam_level: faker.helpers.arrayElement(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5']),
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
