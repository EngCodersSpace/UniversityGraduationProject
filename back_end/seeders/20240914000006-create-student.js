'use strict';

const { faker } = require('@faker-js/faker');
const { user, student, study_plan, level } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const users = await user.findAll();
    const studyPlans = await study_plan.findAll();

    const levels = await level.findAll();
    const students = [];
    for (let i = 0; i < users.length; i++) {
      const usr = users[i];
      students.push({
        student_id: usr.user_id,
        study_plan_id: studyPlans[i % studyPlans.length].study_plan_id,
        student_name: faker.person.fullName(),
        enrollment_year: faker.date.past(5).toISOString().split('T')[0],
        student_level_id: levels[i % levels.length].id,
        student_system: faker.helpers.arrayElement(['General', 'Free Seat', 'Paid']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
    await student.bulkCreate(students);
  },
  down: async (queryInterface, Sequelize) => {
    await student.destroy({ where: {}, truncate: false });
  }
};
