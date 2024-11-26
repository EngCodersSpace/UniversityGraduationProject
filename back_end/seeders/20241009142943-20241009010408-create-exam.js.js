'use strict';
<<<<<<< HEAD

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
=======
const { faker } = require('@faker-js/faker');

// Function to get existing subject IDs
async function getExistingIds(queryInterface) {
  const [results] = await queryInterface.sequelize.query('SELECT subject_id FROM subjects');
  return results.map(subject => subject.subject_id);
}

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const subjectIds = await getExistingIds(queryInterface);
    const exams = [];

    for (let i = 0; i < 10; i++) { 
      exams.push({
        subject_id: faker.helpers.arrayElement(subjectIds), 
        exam_section: faker.helpers.arrayElement(['Computer', 'Communications', 'Civil', 'Architecture']), 
        exam_level: faker.helpers.arrayElement(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5']), 
        exam_term: faker.helpers.arrayElement(['Term 1', 'Term 2']), 
        exam_year: faker.date.past(3).getFullYear().toString(), 
        exam_date: faker.date.future(1, new Date()).toISOString().split('T')[0], 
        exam_time: faker.date.recent().toTimeString().split(' ')[0], 
        exam_day: faker.helpers.arrayElement(['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday']), 
        exam_room: faker.location.streetAddress(), 
>>>>>>> origin/ModelsAndMigrations
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

<<<<<<< HEAD
    
    await exam.bulkCreate(exams);
  },

  down: async (queryInterface, Sequelize) => {
    
=======
    await queryInterface.bulkInsert('exams', exams, {});
  },

  async down(queryInterface, Sequelize) {
>>>>>>> origin/ModelsAndMigrations
    await queryInterface.bulkDelete('exams', null, {});
  }
};
