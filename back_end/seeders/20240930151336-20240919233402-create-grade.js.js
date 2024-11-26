'use strict';
<<<<<<< HEAD

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
=======
const { faker } = require('@faker-js/faker');

async function getExistingIds(queryInterface) {
  const [users] = await queryInterface.sequelize.query('SELECT user_id FROM users');
  const [students] = await queryInterface.sequelize.query('SELECT student_id FROM students');
  const [subjects] = await queryInterface.sequelize.query('SELECT subject_id FROM subjects');

  return {
    userIds: users.map(user => user.user_id),
    studentIds: students.map(student => student.student_id),
    subjectIds: subjects.map(subject => subject.subject_id),
  };
}

module.exports = {
  async up(queryInterface, Sequelize) {
    const { studentIds, subjectIds } = await getExistingIds(queryInterface);

    const grades = [];
    for (let i = 0; i < 10; i++) {
      grades.push({
        student_id: faker.helpers.arrayElement(studentIds),
        subject_id: faker.helpers.arrayElement(subjectIds),
>>>>>>> origin/ModelsAndMigrations
        exam_grade: faker.number.int({ min: 0, max: 100 }), 
        work_grade: faker.number.int({ min: 0, max: 100 }), 
        term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        section: faker.helpers.arrayElement(['Computer', 'Communications', 'Civil', 'Architecture']),
        level: faker.helpers.arrayElement(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5']),
<<<<<<< HEAD
        year_of_issue: faker.date.past(3).getFullYear(), 
        is_absent: faker.datatype.boolean(), 
=======
        year_of_issue: faker.date.past().toISOString().split('T')[0],
        is_absent: faker.datatype.boolean(),
>>>>>>> origin/ModelsAndMigrations
        status: faker.helpers.arrayElement(['Freshman', 'Repeater']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
<<<<<<< HEAD

   
    await grade.bulkCreate(grades);
  },

  down: async (queryInterface, Sequelize) => {
    
=======
    await queryInterface.bulkInsert('grades', grades);
  },

  async down(queryInterface, Sequelize) {
>>>>>>> origin/ModelsAndMigrations
    await queryInterface.bulkDelete('grades', null, {});
  }
};
