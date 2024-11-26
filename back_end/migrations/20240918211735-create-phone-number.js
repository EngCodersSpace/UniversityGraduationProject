'use strict';

const phone_number = require('../models/phone_number');

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('phone_numbers', {

      user_id: {
        type: Sequelize.INTEGER,
        references: {
          model: 'users',
          key: 'user_id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },
      phone_number: {
        type: Sequelize.STRING(25),
        allowNull: false,
      },
      

    });
    await queryInterface.addConstraint('phone_numbers',{
      fields:['user_id','phone_number'],
      type:'primary key',
      name:'phone_number_pkey',
    });


  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('phone_numbers');
  }
};