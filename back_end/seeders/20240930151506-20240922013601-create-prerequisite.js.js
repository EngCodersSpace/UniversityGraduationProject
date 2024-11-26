'use strict';

const { faker } = require('@faker-js/faker');
<<<<<<< HEAD
const { prerequisite, subject, study_plan_elment } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const subjects = await subject.findAll();
    const studyPlanElements = await study_plan_elment.findAll();

    const prerequisites = [];
    for (let i = 0; i < subjects.length; i++) {
      prerequisites.push({
        subject_id: subjects[i].subject_id, 
        study_plan_elment_id: faker.helpers.arrayElement(studyPlanElements).study_plan_elment_id, // Randomly select a study plan element
      });
    }

    await prerequisite.bulkCreate(prerequisites);
  },

  down: async (queryInterface, Sequelize) => {
    await prerequisite.destroy({ where: {}, truncate: true });
  }
=======

async function getExistingIds(queryInterface) {
  const [subjects] = await queryInterface.sequelize.query('SELECT subject_id FROM subjects');
  const [studyPlanElements] = await queryInterface.sequelize.query('SELECT study_plan_elment_id FROM study_plan_elments');

  return {
    subjectIds: subjects.map(subject => subject.subject_id),
    studyPlanElementIds: studyPlanElements.map(element => element.study_plan_elment_id),
  };
}

module.exports = {
  async up(queryInterface, Sequelize) {
    const existingIds = await getExistingIds(queryInterface);
    const prerequisites = [];

    for (let i = 0; i < 10; i++) {
      prerequisites.push({
        subject_id: existingIds.subjectIds[i % existingIds.subjectIds.length],
        study_plan_elment_id: existingIds.studyPlanElementIds[i % existingIds.studyPlanElementIds.length],
        
      });
    }

    await queryInterface.bulkInsert('prerequisites', prerequisites);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('prerequisites', null, {});
  },
>>>>>>> origin/ModelsAndMigrations
};
