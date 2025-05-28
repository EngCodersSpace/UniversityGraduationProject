'use strict';

const { faker } = require('@faker-js/faker');
const { study_plan_elment, subject, doctor ,user } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
   
  

    const studyPlanElements = [];

const sections = [4, 1, 2, 3];
const levels = [2, 3, 4, 5];

const subjectsPerGroup = 5;

// Starting index after Level 1 subjects
const startIndex = 5;

let subjectId = 5; // unique subject id for mapped subjects

for (let sectionIndex = 0; sectionIndex < sections.length; sectionIndex++) {
  const section = sections[sectionIndex];
  for (let levelIndex = 0; levelIndex < levels.length; levelIndex++) {
    const level = levels[levelIndex];
    for (let subjectIndex = 0; subjectIndex < 5; subjectIndex++) {
      const subjectI = await subject.findOne(
        { where: { subject_id: `subject_${subjectIndex}`},
        include: [{
              model: doctor,
              as: "doctors",
              attributes: ['doctor_id'],
              through:{ attributes: [] },
              include:[{
                model:user,
                as:'user',
                attributes: ['user_name'],
              }]
          }]
      });
 studyPlanElements.push({
        study_plan_id: section, 
        subject_id: `subject_${subjectId}`, 
        doctor_id: subjectI.doctors[0].doctor_id??1, 
        section_id: section,
        level_id:  level,
        number_of_units: subjectI.number_of_units, 
        term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }}}



//////////////////////////////////////////////////

for (let sectionIndex = 0; sectionIndex < sections.length; sectionIndex++) {
  const section = sections[sectionIndex];

  for (let levelIndex = 0; levelIndex < levels.length; levelIndex++) {
    const level = levels[levelIndex];

    // Calculate slice start and end index
    const sliceStart = startIndex + (sectionIndex * levels.length + levelIndex) * subjectsPerGroup;
    const sliceEnd = sliceStart + subjectsPerGroup;

    // For each subject in this group
    for (let i = sliceStart; i < sliceEnd; i++) {
      const subjectI = await subject.findOne(
        { where: { subject_id: `subject_${subjectId}`},
        include: [{
              model: doctor,
              attributes: ['doctor_id'],
              through:{ attributes: [] },
              include:[{
                model:user,
                as:'user',
                attributes: ['user_name'],
              }]
          }]
      });
 studyPlanElements.push({
        study_plan_id: section, 
        subject_id: `subject_${subjectId}`, 
        doctor_id: subjectI.doctors[0].doctor_id??1, 
        section_id:   section,
        level_id:  level,
        number_of_units: subjectI.number_of_units, 
        term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
      subjectId++;
    }
  }
}


 for (let i = 0; i < studyPlanElements.length; i += 1000) {
      const chunk = studyPlanElements.slice(i, i + 1000);
      await study_plan_elment.bulkCreate(chunk);
    }
    
  },

  down: async (queryInterface, Sequelize) => {
    await study_plan_elment.destroy({ where: {}, truncate: false });
  }
};
