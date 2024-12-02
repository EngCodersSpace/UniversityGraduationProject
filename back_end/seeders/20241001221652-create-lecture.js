'use strict';

const { faker } = require('@faker-js/faker');
const { lecture, subject, doctor, section, level } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const subjects = await subject.findAll();  // Fetch all subjects
    const doctors = await doctor.findAll();    // Fetch all doctors
    const sections = await section.findAll();  // Fetch all sections
    const levels = await level.findAll();      // Fetch all levels

    const lectures = [];
    const daysOfWeek = ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];

    // Loop through each level and section
    for (const levelItem of levels) {
      for (const sectionItem of sections) {
        // Create a lecture for each day of the week
        for (const day of daysOfWeek) {
          // Randomly choose a subject and a doctor for each lecture
          const randomSubject = subjects[faker.number.int({ min: 0, max: subjects.length - 1 })];
          const randomDoctor = doctors[faker.number.int({ min: 0, max: doctors.length - 1 })];

          const randomHour = faker.number.int({ min: 8, max: 17 });
          const randomMinute = faker.number.int({ min: 0, max: 59 });
          const lectureTime = `${randomHour.toString().padStart(2, '0')}:${randomMinute.toString().padStart(2, '0')}`;

          lectures.push({
            subject_id: randomSubject.subject_id,
            doctor_id: randomDoctor.doctor_id,
            lecture_section_id: sectionItem.id,
            lecture_level_id: levelItem.id,
            term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
            year: new Date().getFullYear(), // Current year
            lecture_time: lectureTime,
            lecture_duration: `${faker.number.int({ min: 1, max: 3 })} hours`, // Duration between 1 and 3 hours
            lecture_day: day,
            lecture_room: faker.string.alphanumeric(5), 
            createdAt: new Date(),
            updatedAt: new Date(),
          });
        }
      }
    }

    // Bulk create lectures
    await lecture.bulkCreate(lectures);
  },

  down: async (queryInterface, Sequelize) => {
    // Remove all lecture entries for rollback
    await queryInterface.bulkDelete('lectures', null, {});
  }
};