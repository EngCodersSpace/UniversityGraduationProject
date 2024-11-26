'use strict';

const { faker } = require('@faker-js/faker');
<<<<<<< HEAD
const { study_plan_elment, study_plan, subject, doctor } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
   
    const studyPlans = await study_plan.findAll();
    const subjects = await subject.findAll();
    const doctors = await doctor.findAll();

    const studyPlanElements = [];
    const numEntries = Math.min(studyPlans.length, subjects.length, doctors.length, 10); 

    for (let i = 0; i < numEntries; i++) {
      studyPlanElements.push({
        study_plan_id: studyPlans[i].study_plan_id, 
        subject_id: subjects[i].subject_id, 
        doctor_id: doctors[i] ? doctors[i].doctor_id : null, 
        section: faker.helpers.arrayElement(['Computer', 'Communications', 'Civil', 'Architecture']),
        level: faker.helpers.arrayElement(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5']),
        number_of_units: Math.floor(Math.random() * 5) + 1, 
=======

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
        number_of_units: faker.number.int({ min: 1, max: 5 }), 
>>>>>>> origin/ModelsAndMigrations
        term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

<<<<<<< HEAD
    await study_plan_elment.bulkCreate(studyPlanElements);
  },

  down: async (queryInterface, Sequelize) => {
    await study_plan_elment.destroy({ where: {}, truncate: true });
  }
=======
    await queryInterface.bulkInsert('study_plan_elments', studyPlanElements);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('study_plan_elments', null, {});
  },
>>>>>>> origin/ModelsAndMigrations
};
