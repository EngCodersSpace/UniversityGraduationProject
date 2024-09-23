'use strict';
const { faker } = require('@faker-js/faker');

module.exports = {
  async up(queryInterface, Sequelize) {
    const students = [];

    // Assume we already have some users created, and we need to link each student to a user
    for (let i = 1; i <= 10; i++) {  // 10 fake students
      students.push({
        student_id: i,  // This should match with a valid user_id in the users table
        student_name: faker.person.fullName(), // Updated for full name
        student_section: faker.helpers.arrayElement(['Computer', 'Communications', 'Civil', 'Architecture']),
        enrollment_year: faker.date.past(5, new Date()).getFullYear().toString(),
        student_level: faker.helpers.arrayElement(['Freshman', 'Sophomore', 'Junior', 'Senior']),
        status: faker.helpers.arrayElement(['Active', 'Inactive']),
        address: faker.location.streetAddress(), // Updated for street address
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await queryInterface.bulkInsert('students', students, {});
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('students', null, {});
  }
};
