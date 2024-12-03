'use strict';

const { faker } = require('@faker-js/faker');
const { exam, subject, section, level } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
  
    // const subjects = await subject.findAll();
    // const sections = await section.findAll();
    // const levels = await level.findAll();
    // const examRooms = Array.from({ length: 100 }, (_, i) => `Hall ${i + 1}`); // Create exam rooms from Hall 1 to Hall 100
    // const exams = [];
    // const terms = ["Term 1", "Term 2"];
    // for (let s = 0; s < sections.length; s++) {
    //   for (let l = 0; l < levels.length; l++) {
    //     for(let t=0;t<2;t++){
    //       for (let su = 0; su < subjects.length; su++) { 
    //           const exam_date = faker.date.anytime();
    //             const exam_year = exam_date.getFullYear();
    //             exams.push({
    //               subject_id: subjects[su].subject_id,
    //               exam_section_id: sections[s].id,
    //               exam_level_id: levels[l].id,
    //               exam_term: terms[t],
    //               exam_year: exam_year, // Set the exam year
    //               exam_date: exam_date, // Set the exam date
    //               exam_time: faker.helpers.arrayElement(['08:00:00', '10:00:00']), // Random time between 08:00:00 and 16:00:00
    //               exam_day: faker.helpers.arrayElement(['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday']),
    //               exam_room: examRooms[faker.number.int({ min: 0, max: examRooms.length - 1 })], // Randomly select a hall
    //               createdAt: new Date(),
    //               updatedAt: new Date(),
    //             });
    //         }
    //       } 
    //     }
    // }

    // await exam.bulkCreate(exams);
  },
  

  down: async (queryInterface, Sequelize) => {
    await exam.destroy({ where: {}, truncate: false });
  }
};