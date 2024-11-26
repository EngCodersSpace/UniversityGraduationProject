<<<<<<< HEAD
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
=======
const { faker } = require('@faker-js/faker');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const subjects = [];
    for (let i = 0; i < 10; i++) {
      subjects.push({
        subject_id: (i + 1).toString(), 
        subject_name: faker.lorem.words(2),
        number_of_units: faker.number.int({ min: 1, max: 5 }),
        subject_description: faker.lorem.sentence(),
>>>>>>> origin/ModelsAndMigrations
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
<<<<<<< HEAD

    await subject.bulkCreate(subjects);
  },

  down: async (queryInterface, Sequelize) => {
    await subject.destroy({ where: {}, truncate: true });
  }
=======
    await queryInterface.bulkInsert('subjects', subjects);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('subjects', null, {});
  },
>>>>>>> origin/ModelsAndMigrations
};
