'use strict';

const { faker } = require('@faker-js/faker');
const { exam, subject, section, level } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const subjects = await subject.findAll();
    const levels = await level.findAll();
    const sections = await section.findAll();

    const exams = [];
    const examRooms = Array.from({ length: 100 }, (_, i) => `Hall ${i + 1}`); // Create exam rooms from Hall 1 to Hall 100

    for (let i = 0; i < Math.min(subjects.length, 10); i++) {
      // Randomly pick a year between the last 2 years and the current year
      const exam_year = new Date().getFullYear(); // Use the current year
      
      // Pick a random day in a specific month, e.g., June (6)
      const exam_date = `${exam_year}-06-${faker.datatype.number({ min: 1, max: 30 })}`; // Example: 2023-06-15

      exams.push({
        subject_id: subjects[i].subject_id,
        exam_section_id: sections[i % sections.length].id,
        exam_level_id: levels[i % levels.length].id,
        exam_term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        exam_year: exam_year, // Set the exam year
        exam_date: exam_date, // Set the exam date
        exam_time: `${faker.datatype.number({ min: 8, max: 16 })}:00:00`, // Random time between 08:00:00 and 16:00:00
        exam_day: faker.helpers.arrayElement(['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday']),
        exam_room: examRooms[faker.datatype.number({ min: 0, max: examRooms.length - 1 })], // Randomly select a hall
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    // Insert the exam records
    await exam.bulkCreate(exams);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('exams', null, {});
  }
};