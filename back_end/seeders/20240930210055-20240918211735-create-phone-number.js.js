<<<<<<< HEAD
'use strict';

const { faker } = require('@faker-js/faker');
const { phone_number, user } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
  
    const users = await user.findAll();

    const phoneNumbers = [];
    const numEntries = Math.min(users.length, 10); 

    for (let i = 0; i < numEntries; i++) {
      phoneNumbers.push({
        user_id: users[i].user_id, 
        phone_number: faker.phone.number(), 
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await phone_number.bulkCreate(phoneNumbers);
  },

  down: async (queryInterface, Sequelize) => {
    await phone_number.destroy({ where: {}, truncate: true });
  }
=======
const { faker } = require('@faker-js/faker');

async function getExistingIds(queryInterface) {
  const [users] = await queryInterface.sequelize.query('SELECT user_id FROM users');

  return {
    userIds: users.map(user => user.user_id),
  };
}

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const existingIds = await getExistingIds(queryInterface);
    const phoneNumbers = [];

    for (let i = 0; i < 10; i++) {
      phoneNumbers.push({
        phone_number: faker.phone.number(),
        user_id: existingIds.userIds[i % existingIds.userIds.length], 
        
      });
    }
    await queryInterface.bulkInsert('phone_numbers', phoneNumbers);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('phone_numbers', null, {});
  },
>>>>>>> origin/ModelsAndMigrations
};
