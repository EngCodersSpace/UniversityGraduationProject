'use strict';
const { faker } = require('@faker-js/faker');

async function getExistingIds(queryInterface) {
  const [users] = await queryInterface.sequelize.query('SELECT user_id FROM users');
  const [studyPlans] = await queryInterface.sequelize.query('SELECT study_plan_id FROM study_plans');

  return {
    userIds: users.map(user => user.user_id),
    studyPlanIds: studyPlans.map(plan => plan.study_plan_id),
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
        student_name: faker.person.fullName(),
        student_section: faker.helpers.arrayElement(['Computer', 'Communications', 'Civil', 'Architecture']),
        enrollment_year: faker.date.past(5).toISOString().split('T')[0],
        student_level: faker.helpers.arrayElement(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5']),
        student_system: faker.helpers.arrayElement(['General', 'Free Seat', 'Paid']), 
        profile_picture: faker.image.avatar(),
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
