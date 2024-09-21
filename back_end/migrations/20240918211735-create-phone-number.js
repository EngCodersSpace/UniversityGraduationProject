'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('phone_numbers', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      user_id: {
        type: Sequelize.INTEGER,
        references: {
          model: 'users' ,
          key:'user_id',
        },
        onDelete:'CASCADE',
        onUpdate:'CASCADE',  
      },
      phone_number: {
        type: Sequelize.STRING,
        allowNull: false,
        unique:true,
      },
      
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('phone_numbers');
  }
};