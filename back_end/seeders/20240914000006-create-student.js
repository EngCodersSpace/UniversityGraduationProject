'use strict';
const { faker } = require('@faker-js/faker');
const { types } = require('joi');

async function getExistingIds(queryInterface) {
  const [users] = await queryInterface.sequelize.query('SELECT user_id FROM users');
  const [studyPlans] = await queryInterface.sequelize.query('SELECT study_plan_id FROM study_plans');
  const [sections] = await queryInterface.sequelize.query ('SELECT id FROM sections');
  const [levels] = await queryInterface.sequelize.query ('SELECT id FROM levels');
  return {
    userIds: users.map(user => user.user_id),
    studyPlanIds: studyPlans.map(plan => plan.study_plan_id),
    ssectionIds:sections.map(section=>section.id),
    levelIds:levels.map(level=>level.id),
  };
}

module.exports = {
  async up(queryInterface, Sequelize) {
    const existingIds = await getExistingIds(queryInterface);
    const students = [];

    // Check if there are enough study plan IDs
    if (existingIds.studyPlanIds.length === 0) {
      throw new Error('No study plan IDs found. Please ensure there are entries in the study_plans table.');
    }

    for (let i = 0; i < 10; i++) {
      students.push({
        student_id: existingIds.userIds[i % existingIds.userIds.length],
        study_plan_id: existingIds.studyPlanIds[i % existingIds.studyPlanIds.length],
        student_section_id:faker.helpers.arrayElement(sectionIds),
        enrollment_year: faker.date.past(5).toISOString().split('T')[0],
        student_level_id:faker.helpers.arrayElement(levelIds),
        student_system: faker.helpers.arrayElement(['General', 'Free Seat', 'Paid']), 
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await queryInterface.bulkInsert('students', students);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('students', null, {});
  },
};
