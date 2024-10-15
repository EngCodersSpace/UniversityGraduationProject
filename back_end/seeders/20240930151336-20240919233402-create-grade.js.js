'use strict';

const { faker } = require('@faker-js/faker');
const { grade, student, subject } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const students = await student.findAll();
    const subjects = await subject.findAll();

    const grades = [];
    const numEntries = Math.min(students.length, subjects.length, 10); 

    for (let i = 0; i < numEntries; i++) {
      grades.push({
        student_id: students[i].student_id, 
        subject_id: subjects[i].subject_id, 
        exam_grade: faker.number.int({ min: 0, max: 100 }), 
        work_grade: faker.number.int({ min: 0, max: 100 }), 
        term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        section: faker.helpers.arrayElement(['Computer', 'Communications', 'Civil', 'Architecture']),
        level: faker.helpers.arrayElement(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5']),
        year_of_issue: faker.date.past(2).getFullYear(), 
        is_absent: faker.datatype.boolean(), 
        status: faker.helpers.arrayElement(['Freshman', 'Repeater']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

   
    await grade.bulkCreate(grades);
  },

  down: async (queryInterface, Sequelize) => {
    
    await queryInterface.bulkDelete('grades', null, {});
  }
};
