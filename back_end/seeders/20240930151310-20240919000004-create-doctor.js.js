<<<<<<< HEAD
'use strict';

const { faker } = require('@faker-js/faker');
const { user, doctor } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const users = await user.findAll();

    
    const doctors = users.map(usr => ({
      doctor_id: usr.user_id, 
      doctor_name: faker.person.fullName(),
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
=======
const { faker } = require('@faker-js/faker');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const doctors = [];
    const userIds = await getExistingIds(queryInterface);

    for (const userId of userIds) {
      doctors.push({
        doctor_id: userId, 
        doctor_name: faker.person.fullName(),
        department: faker.commerce.department(),
        status: faker.helpers.arrayElement(['Active', 'Inactive']),
        academic_degree: faker.helpers.arrayElement(['Doctor', 'Professor', 'Master', 'Bachelor']),
        administrative_position: faker.helpers.arrayElement(['Dean', 'Vice Dean', 'Lecturer', 'Department Chair', 'None']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await queryInterface.bulkInsert('doctors', doctors);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('doctors', null, {});
  },
};

async function getExistingIds(queryInterface) {
  const [results] = await queryInterface.sequelize.query('SELECT user_id FROM users');
  return results.map(user => user.user_id);
}
>>>>>>> origin/ModelsAndMigrations
