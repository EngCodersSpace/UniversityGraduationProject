'use strict';

const { faker } = require('@faker-js/faker');
const { study_plan_elment, study_plan, subject, doctor ,section, level } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
   
    const studyPlans = await study_plan.findAll();
    const subjects = await subject.findAll();
    const doctors = await doctor.findAll();
    const sections = await section.findAll();
    const levels = await level.findAll();

    const studyPlanElements = [];
    const numEntries = Math.min(studyPlans.length, subjects.length, doctors.length, 10); 

    for (let i = 0; i < numEntries; i++) {
      studyPlanElements.push({
        study_plan_id: studyPlans[i].study_plan_id, 
        subject_id: subjects[i].subject_id, 
        doctor_id: doctors[i] ? doctors[i].doctor_id : null, 
        section_id: sections[i % sections.length].id,
        level_id:  levels[i % levels.length].id,
        number_of_units: Math.floor(Math.random() * 5) + 1, 
        term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await study_plan_elment.bulkCreate(studyPlanElements);
  },

  down: async (queryInterface, Sequelize) => {
    await study_plan_elment.destroy({ where: {}, truncate: false });
  }
};
