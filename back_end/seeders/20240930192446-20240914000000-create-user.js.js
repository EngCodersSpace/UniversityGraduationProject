<<<<<<< HEAD
'use strict';
const { user } = require('../models'); 
const { faker } = require('@faker-js/faker'); 
=======
const { faker } = require('@faker-js/faker');
>>>>>>> origin/ModelsAndMigrations

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const users = [];
    for (let i = 0; i < 10; i++) {
      users.push({
<<<<<<< HEAD
        user_id: i + 1,
        user_name: faker.person.fullName(), 
        date_of_birth: faker.date.past(20),
        email: faker.internet.email(),
        password: faker.internet.password(), 
        permission: faker.helpers.arrayElement(['student', 'teacher', 'admin', 'staff']), 
        reset_token: null, 
        reset_token_expiry: null, 
=======
        user_id: i + 1, 
        user_name: faker.person.fullName(),
        date_of_birth: faker.date.past(30),
        email: faker.internet.email(),
        permission: faker.helpers.arrayElement(['student', 'teacher', 'admin', 'staff']),
        password: faker.internet.password(),
>>>>>>> origin/ModelsAndMigrations
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
<<<<<<< HEAD
    await user.bulkCreate(users);
  },

  down: async (queryInterface, Sequelize) => {
    await user.destroy({ where: {}, truncate: true });
  }
=======
    await queryInterface.bulkInsert('users', users);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('users', null, {});
  },
>>>>>>> origin/ModelsAndMigrations
};
