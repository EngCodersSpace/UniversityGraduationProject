'use strict';
const bcrypt = require('bcrypt');
const { faker } = require('@faker-js/faker');

module.exports = {
  async up(queryInterface, Sequelize) {
    const users = [];

    for (let i = 0; i < 10; i++) {
      users.push({
        user_id: i + 1,
        user_name: faker.person.fullName(), // Use fullName for user name
        date_of_birth: faker.date.past(30, new Date('2000-01-01')),
        email: faker.internet.email(),
        phone_number: faker.phone.number(), // Phone number method
        permission: faker.helpers.arrayElement(['student', 'teacher', 'admin', 'staff']),
        password: bcrypt.hashSync('password', 10), // Default password for demo
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await queryInterface.bulkInsert('users', users, {});
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('users', null, {});
  }
};
