'use strict';
const { faker } = require('@faker-js/faker');
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    const levels = [];
    for (let i = 0; i < 10; i++) {
      levels.push({
        id: i + 1,
        level_name:faker.helpers.arrayElement(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
    await queryInterface.bulkInsert('levels', levels);
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.bulkDelete('levels', null, {});
  },
};
