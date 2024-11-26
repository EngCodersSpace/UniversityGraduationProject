<<<<<<< HEAD
'use strict';

const { faker } = require('@faker-js/faker');
const { study_plan } = require('../models'); 
=======
const { faker } = require('@faker-js/faker');
>>>>>>> origin/ModelsAndMigrations

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const studyPlans = [];
<<<<<<< HEAD
    for (let i = 0; i < 10; i++) {
      studyPlans.push({
        study_plan_name: faker.commerce.department(), 
=======
    for (let i = 0; i < 5; i++) {
      studyPlans.push({
        study_plan_id: i + 1,
        study_plan_name: faker.lorem.words(3),
>>>>>>> origin/ModelsAndMigrations
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
<<<<<<< HEAD

    
    await study_plan.bulkCreate(studyPlans);
  },

  down: async (queryInterface, Sequelize) => {
    await study_plan.destroy({ where: {}, truncate: true });
  }
=======
    await queryInterface.bulkInsert('study_plans', studyPlans);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('study_plans', null, {});
  },
>>>>>>> origin/ModelsAndMigrations
};
