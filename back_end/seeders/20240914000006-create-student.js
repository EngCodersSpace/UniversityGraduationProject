'use strict';

const { faker } = require('@faker-js/faker');
const { user, student, study_plan, level } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const users = await user.findAll(); // Get all users
    const studyPlans = await study_plan.findAll(); // Get all study plans
    const levels = await level.findAll(); // Get all levels

    const students = [];
    for (let i = 0; i < users.length; i++) {
      const usr = users[i];
      // Prepare student data based on user and related data
      students.push({
        student_id: usr.user_id, // Associating student with the corresponding user
        study_plan_id: studyPlans[i % studyPlans.length].study_plan_id, // Select study plan cyclically
        student_name: faker.person.fullName(), // Fake student name
        enrollment_year: faker.date.past(5).getFullYear(), // Get only the year
        student_level_id: levels[i % levels.length].id, // Assign level cyclically
        student_system: faker.helpers.arrayElement(['General', 'Free Seat', 'Paid']), // Randomly assign a student system
        createdAt: new Date(), // Set creation date
        updatedAt: new Date(), // Set updated date
      });
    }

    // Bulk insert all student records
    await student.bulkCreate(students);
  },
  
  down: async (queryInterface, Sequelize) => {
    // Clean up the student data when rolling back
    await student.destroy({ where: {}, truncate: false });
  }
};