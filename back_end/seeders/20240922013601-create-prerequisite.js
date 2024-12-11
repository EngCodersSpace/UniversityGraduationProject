'use strict';

const { faker } = require('@faker-js/faker');
const { prerequisite, subject, study_plan_elment } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const subjects = await subject.findAll();
    const studyPlanElements = await study_plan_elment.findAll();

    const prerequisites = [];
    for (let i = 0; i < subjects.length; i++) {
      prerequisites.push({
        subject_id: subjects[i].subject_id, 
        study_plan_elment_id: studyPlanElements[i%studyPlanElements.length].study_plan_elment_id, // Randomly select a study plan element
      });
    }

    await prerequisite.bulkCreate(prerequisites);
  },

  down: async (queryInterface, Sequelize) => {
    await prerequisite.destroy({ where: {}, truncate: false });
  }
};
