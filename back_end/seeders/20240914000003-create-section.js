'use strict';
/** @type {import('sequelize-cli').Migration} */
const { faker } = require('@faker-js/faker');
const { section } = require('../models'); 
module.exports = {
   up : async (queryInterface, Sequelize) =>{
    const sections = [];

    for (let i = 0; i < 10; i++) {
      sections.push({
        id: i + 1, 
        section_name: faker.helpers.arrayElement(['Computer', 'Communications', 'Civil', 'Architecture']), 
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await section.bulkCreate(sections);
  },

   down : async (queryInterface, Sequelize) =>{
    await section.destroy({ where: {}, truncate: true });
  },
};
