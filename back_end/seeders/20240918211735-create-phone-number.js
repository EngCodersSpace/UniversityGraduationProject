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
    await phone_number.destroy({ where: {}, truncate: false });
  }
};
