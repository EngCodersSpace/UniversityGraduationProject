'use strict';

const { faker } = require('@faker-js/faker');

async function getExistingIds(queryInterface) {
  const [studyPlans] = await queryInterface.sequelize.query('SELECT study_plan_id FROM study_plans');
  const [subjects] = await queryInterface.sequelize.query('SELECT subject_id FROM subjects');
  const [doctors] = await queryInterface.sequelize.query('SELECT doctor_id FROM doctors');

  return {
    studyPlanIds: studyPlans.map(plan => plan.study_plan_id),
    subjectIds: subjects.map(subject => subject.subject_id),
    doctorIds: doctors.map(doctor => doctor.doctor_id),
  };
}

module.exports = {
  async up(queryInterface, Sequelize) {
    const existingIds = await getExistingIds(queryInterface);
    const studyPlanElements = [];

    for (let i = 0; i < 10; i++) {
      studyPlanElements.push({
        study_plan_id: existingIds.studyPlanIds[i % existingIds.studyPlanIds.length],
        subject_id: existingIds.subjectIds[i % existingIds.subjectIds.length],
        doctor_id: existingIds.doctorIds[i % existingIds.doctorIds.length],
        section: faker.helpers.arrayElement(['Computer', 'Communications', 'Civil', 'Architecture']),
        level: faker.helpers.arrayElement(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5']),
        number_of_units: faker.number.int({ min: 1, max: 5 }), // Use faker.number.int for random number
        term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await queryInterface.bulkInsert('study_plan_elments', studyPlanElements);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('study_plan_elments', null, {});
  },
};
