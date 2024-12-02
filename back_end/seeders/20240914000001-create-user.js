'use strict';
const { user, section } = require('../models');
const { faker } = require('@faker-js/faker');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const sections = await section.findAll();
    const users = [];
    for (let i = 0; i < 10; i++) {
      users.push({
        user_id: i + 1,
        user_name: faker.person.fullName(),
        user_section_id: sections[i % sections.length].id,
        date_of_birth: faker.date.past(20),
        profile_picture: faker.internet.url(),
        email: faker.internet.email(),
        password: faker.internet.password(),
        permission: faker.helpers.arrayElement(['student', 'teacher', 'admin', 'staff']),
        resetToken: faker.internet.url(),
        resetTokenExpiry: faker.date.future(),
        refreshToken: faker.internet.url(),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
    await user.bulkCreate(users);
  },

  down: async (queryInterface, Sequelize) => {
    await user.destroy({ where: {}, truncate: true });
  }
};
