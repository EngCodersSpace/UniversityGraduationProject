'use strict';

const { faker } = require('@faker-js/faker');
const { lecture, subject, doctor, section, level } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const subjects = await subject.findAll();
    const doctors = await doctor.findAll();
    const sections = await section.findAll();
    const levels = await level.findAll();

    const lectures = [];
    const daysOfWeek = ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];

    for (let i = 0; i < Math.min(subjects.length, doctors.length, 6); i++) { // Create 6 lectures for each day of the week
      const randomHour = faker.number.int({ min: 8, max: 17 });
      const randomMinute = faker.number.int({ min: 0, max: 59 });
      const lectureTime = `${randomHour.toString().padStart(2, '0')}:${randomMinute.toString().padStart(2, '0')}`;

      // Generate a random hall from Hall 1 to Hall 100
      const lecture_room = `Hall ${faker.number.int({ min: 1, max: 100 })}`;

      lectures.push({
        subject_id: subjects[i % subjects.length].subject_id,
        doctor_id: doctors[i % doctors.length].doctor_id,
        lecture_section_id: sections[i % sections.length].id,
        lecture_level_id: levels[i % levels.length].id,
        term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        year: new Date().getFullYear(), // Set the year to the current year
        lecture_time: lectureTime,
        lecture_duration: faker.number.int({ min: 1, max: 400 }), // Adjust as needed for lecture duration
        lecture_day: daysOfWeek[i], // Assign each lecture to a different day
        lecture_room: lecture_room, // Set the lecture room to a random hall
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    // Insert the lecture records
    await lecture.bulkCreate(lectures);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('lectures', null, {});
  }
};