'use strict';

const { faker } = require('@faker-js/faker');
const { exam, subject, section, level } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const subjects = await subject.findAll();
    const levels = await level.findAll();
    const sections = await section.findAll();

    const additionalHalls = [];

    // Generate hall names from 1 to 100
    for (let i = 1; i <= 100; i++) {
      additionalHalls.push(`hall ${i}`);
    }

    const exams = [];
    for (let i = 0; i < Math.min(subjects.length, 10); i++) {
      // Select a year for the exam
      const exam_year = faker.date.past(2).getFullYear();
      
      // Generate an exam date within the selected year
      const exam_date = faker.date.between(new Date(`${exam_year}-01-01`), new Date(`${exam_year}-12-31`));

      exams.push({
        subject_id: subjects[i].subject_id, 
        exam_section_id: sections[i % sections.length].id,
        exam_level_id: levels[i % levels.length].id,
        exam_term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        exam_year, // Use the same year for exam_year
        exam_date: exam_date.toISOString().split('T')[0], // Format the date correctly
        exam_time: faker.date.future(1).toISOString().split('T')[1].slice(0, 8), 
        exam_day: exam_date.toLocaleString('en-US', { weekday: 'long' }), // Get the day of the week from the date
        exam_room: faker.helpers.arrayElement(additionalHalls), // Randomly assign a room
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    // Bulk create exam entries
    await exam.bulkCreate(exams);
  },

  down: async (queryInterface, Sequelize) => {
    // Remove all exam entries for rollback
    await queryInterface.bulkDelete('exams', null, {});
  }
};