'use strict';
const { faker } = require('@faker-js/faker');
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    const sections = [];
    for (let i = 0; i < 10; i++) {
      sections.push({
        id: i + 1,
        section_name:faker.helpers.arrayElement(['Computer', 'Communications', 'Civil', 'Architecture']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
    await queryInterface.bulkInsert('sections', sections);
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.bulkDelete('sections', null, {});
  },
};
