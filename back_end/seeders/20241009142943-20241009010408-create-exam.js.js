'use strict';
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
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await queryInterface.bulkInsert('exams', exams, {});
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('exams', null, {});
  }
};
