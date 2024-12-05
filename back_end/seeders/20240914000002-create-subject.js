'use strict';

const { faker } = require('@faker-js/faker');
const { subject } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
  
    const subjects = [];
    for (let i = 0; i < 10; i++) {
      subjects.push({
        subject_id: `SUB${i + 1}`, 
        subject_name: faker.lorem.words(2), 
        number_of_units: Math.floor(Math.random() * 5) + 1, 
        subject_description: faker.lorem.sentence(), 
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await subject.bulkCreate(subjects);
  },

  down: async (queryInterface, Sequelize) => {
    await subject.destroy({ where: {}, truncate: true });
  }
};
