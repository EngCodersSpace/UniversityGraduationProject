'use strict';

const { faker } = require('@faker-js/faker');
const { user, doctor } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const users = await user.findAll();

    
    const doctors = users.map(usr => ({
      doctor_id: usr.user_id, 
      department: faker.commerce.department(),
      status: faker.helpers.arrayElement(['Active', 'Inactive']),
      academic_degree: faker.helpers.arrayElement(['Doctor', 'Professor', 'Master', 'Bachelor']),
      administrative_position: faker.helpers.arrayElement(['Dean', 'Vice Dean', 'Lecturer', 'Department Chair', 'None']),
      createdAt: new Date(),
      updatedAt: new Date(),
    }));

    await doctor.bulkCreate(doctors);
  },

  down: async (queryInterface, Sequelize) => {
    await doctor.destroy({ where: {}, truncate: true });
  }
};
