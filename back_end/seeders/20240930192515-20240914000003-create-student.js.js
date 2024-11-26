'use strict';

const { faker } = require('@faker-js/faker');
const { user, student, study_plan } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
   
    const users = await user.findAll();
    const studyPlans = await study_plan.findAll();

   
    const students = [];
    for (let i = 0; i < users.length; i++) {
      const usr = users[i];

      students.push({
        student_id: usr.user_id, 
        study_plan_id: studyPlans[i % studyPlans.length].study_plan_id, 
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

    
    await student.bulkCreate(students);
  },

  down: async (queryInterface, Sequelize) => {
    await student.destroy({ where: {}, truncate: true });
  }
};
