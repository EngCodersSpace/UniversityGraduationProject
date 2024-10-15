'use strict';

const { faker } = require('@faker-js/faker');
const { study_plan } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const studyPlans = [];
    for (let i = 0; i < 10; i++) {
      studyPlans.push({
        study_plan_name: faker.commerce.department(), 
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    
    await study_plan.bulkCreate(studyPlans);
  },

  down: async (queryInterface, Sequelize) => {
    await study_plan.destroy({ where: {}, truncate: true });
  }
};
