'use strict';
/** @type {import('sequelize-cli').Migration} */
const { section } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const sections = [
      { id: 1, section_name: 'Computer', createdAt: new Date(), updatedAt: new Date() },
      { id: 2, section_name: 'Communications', createdAt: new Date(), updatedAt: new Date() },
      { id: 3, section_name: 'Civil', createdAt: new Date(), updatedAt: new Date() },
      { id: 4, section_name: 'Architecture', createdAt: new Date(), updatedAt: new Date() }
    ];

    await section.bulkCreate(sections);
  },

  down: async (queryInterface, Sequelize) => {
    await section.destroy({ where: {}, truncate: true });
  },
};
