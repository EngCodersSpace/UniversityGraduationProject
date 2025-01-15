'use strict';

const { faker } = require('@faker-js/faker');
const { phone_number, user } = require('../models');
const { DATE } = require('sequelize');

module.exports = {
  up: async (queryInterface, Sequelize) => {

    const users = await user.findAll();

    const phoneNumbers = [];

    for (const userItem of users) {
      const numberOfphones = faker.number.int({ min: 1, max: 3 });
      for (let i = 0; i < numberOfphones; i++) {
        const phoneNumber = faker.phone.number();
        phoneNumbers.push({
          user_id: userItem.user_id,
          phone_number: phoneNumber,

        });

      }
    }


    await phone_number.bulkCreate(phoneNumbers);
  },

  down: async (queryInterface, Sequelize) => {
    await phone_number.destroy({ where: {}, truncate: false });
  }
};
