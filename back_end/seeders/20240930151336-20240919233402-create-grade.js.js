'use strict';
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
    for (let i = 0; i < 100; i++) {
      grades.push({
        student_id: faker.helpers.arrayElement(studentIds),
        subject_id: faker.helpers.arrayElement(subjectIds),
        exam_grade: faker.number.int({ min: 0, max: 100 }), // Updated method
        work_grade: faker.number.int({ min: 0, max: 100 }), // Updated method
        term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        section: faker.helpers.arrayElement(['Computer', 'Communications', 'Civil', 'Architecture']),
        level: faker.helpers.arrayElement(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5']),
        year_of_issue: faker.date.past().toISOString().split('T')[0],
        is_absent: faker.datatype.boolean(),
        status: faker.helpers.arrayElement(['Freshman', 'Repeater']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
    await queryInterface.bulkInsert('grades', grades);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('grades', null, {});
  }
};
