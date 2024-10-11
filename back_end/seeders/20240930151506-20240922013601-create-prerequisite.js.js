'use strict';

const { faker } = require('@faker-js/faker');

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
};
