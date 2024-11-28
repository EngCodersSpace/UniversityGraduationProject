'use strict';

const { faker } = require('@faker-js/faker');
const { lecture, subject, doctor ,section ,level} = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const subjects = await subject.findAll();
    const doctors = await doctor.findAll();
    const sections = await section.findAll();
    const levels = await level.findAll();

    const lectures = [];
    for (let i = 0; i < Math.min(subjects.length, doctors.length, 50); i++) { 
      const randomHour = faker.number.int({ min: 8, max: 17 }); 
      const randomMinute = faker.number.int({ min: 0, max: 59 }); 
      const lectureTime = `${randomHour.toString().padStart(2, '0')}:${randomMinute.toString().padStart(2, '0')}`; 

      lectures.push({
        subject_id: subjects[i%subjects.length].subject_id, 
        doctor_id: doctors[i%doctors.length].doctor_id, 
        lecture_section_id:sections[i%sections.length].id,
        lecture_level_id: levels[i%levels.length].id,
        term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        year: faker.date.past().getFullYear(), 
        lecture_time: lectureTime, 
        lecture_duration: `${faker.number.int({ min: 1, max: 3 })} hours`, 
        lecture_day: faker.helpers.arrayElement(['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday']),
        lecture_room: faker.string.alphanumeric(5), 
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    
    await lecture.bulkCreate(lectures);
  },

  down: async (queryInterface, Sequelize) => {
    
    await queryInterface.bulkDelete('lectures', null, {});
  }
};
