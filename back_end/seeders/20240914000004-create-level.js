'use strict';
/** @type {import('sequelize-cli').Migration} */
const { faker } = require('@faker-js/faker');
const { level } = require('../models'); 
module.exports = {
   up : async (queryInterface, Sequelize) =>{
    const levels = [];

    for (let i = 0; i < 10; i++) {
      levels.push({
        id: i + 1, 
        level_name: faker.helpers.arrayElement(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5']), 
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await level.bulkCreate(levels);
  },

   down : async (queryInterface, Sequelize) =>{
    await level.destroy({ where: {}, truncate: true });
  },
};
