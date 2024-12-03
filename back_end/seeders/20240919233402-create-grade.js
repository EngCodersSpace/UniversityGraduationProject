'use strict';

const { faker } = require('@faker-js/faker');
const { grade, student, subject  , section, level } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const students = await student.findAll();
    const subjects = await subject.findAll();
    const sections = await section.findAll();
    const levels = await level.findAll();

    const grades = [];
    const numEntries = Math.min(students.length, subjects.length, 10); 

    for (let i = 0; i < numEntries; i++) {
      grades.push({
        student_id: students[i].student_id, 
        subject_id: subjects[i].subject_id, 
        exam_grade: faker.number.int({ min: 0, max: 100 }), 
        work_grade: faker.number.int({ min: 0, max: 100 }), 
        term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        section_id: sections[i % sections.length].id,
        level_id:  levels[i % levels.length].id,
        year_of_issue: faker.date.past(3).getFullYear(), 
        is_absent: faker.datatype.boolean(), 
        status: faker.helpers.arrayElement(['Freshman', 'Repeater']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

   
    await grade.bulkCreate(grades);
  },

  down: async (queryInterface, Sequelize) => {
    
    await grade.destroy({ where: {}, truncate: false });
  }
};
