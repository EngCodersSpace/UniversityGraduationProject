'use strict';
/** @type {import('sequelize-cli').Migration} */
const { section } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const sections = [
      { id: 1, section_name: {
        'en':'Computer',
        'ar':'حاسبات'
      }, createdAt: new Date(), updatedAt: new Date() },
      { id: 2, section_name: {
        'en':'Communications',
        'ar':'اتصالات'
      }, createdAt: new Date(), updatedAt: new Date() },
      { id: 3, section_name: {
        'en':'Civil',
        'ar':'مدني'
      }, createdAt: new Date(), updatedAt: new Date() },
      { id: 4, section_name: {
        'en':'Architecture',
        'ar':'معماري'
      }, createdAt: new Date(), updatedAt: new Date() }
    ];

    await section.bulkCreate(sections);
  },

  down: async (queryInterface, Sequelize) => {
    await section.destroy({ where: {}, truncate: false });
  },
};
