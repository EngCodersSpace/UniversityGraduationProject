'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('phone_numbers', {

      user_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        references: {
          model: 'users',
          key: 'user_id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },
      phone_number: {
        type: Sequelize.STRING,
        primaryKey: true,
        allowNull: false,
      },
      

    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('phone_numbers');
  }
};