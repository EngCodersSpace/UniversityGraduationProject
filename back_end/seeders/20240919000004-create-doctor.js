'use strict';

const { faker } = require('@faker-js/faker');
const { user, doctor } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Fetch all users from the database
    const users = await user.findAll();

    // Prepare doctor records based on user data
    const doctors = users.map(usr => ({
      doctor_id: usr.user_id,  // Associate doctor with the corresponding user
      status: faker.helpers.arrayElement(['Active', 'Inactive']), // Randomly assign status
      academic_degree: faker.helpers.arrayElement(['Doctor', 'Professor', 'Master', 'Bachelor']), // Assign academic degree
      administrative_position: faker.helpers.arrayElement(['Dean', 'Vice Dean', 'Lecturer', 'Department Chair', 'None']), // Assign position
      createdAt: new Date(), // Set creation date
      updatedAt: new Date(), // Set updated date
    }));

    // Bulk insert all doctor records into the database
    await doctor.bulkCreate(doctors);
  },

  down: async (queryInterface, Sequelize) => {
    // Remove all doctor records when rolling back
    await doctor.destroy({ where: {}, truncate: false });
  }
};