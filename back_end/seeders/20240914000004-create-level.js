'use strict';
/** @type {import('sequelize-cli').Migration} */
const { level } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const levels = [
      { id: 1, level_name: 1, createdAt: new Date(), updatedAt: new Date() },
      { id: 2, level_name: 2, createdAt: new Date(), updatedAt: new Date() },
      { id: 3, level_name: 3, createdAt: new Date(), updatedAt: new Date() },
      { id: 4, level_name: 4, createdAt: new Date(), updatedAt: new Date() },
      { id: 5, level_name: 5, createdAt: new Date(), updatedAt: new Date() }
    ];

    await level.bulkCreate(levels);
  },

  down: async (queryInterface, Sequelize) => {
    await level.destroy({ where: {}, truncate: false });
  },
};