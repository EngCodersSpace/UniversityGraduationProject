'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('users', {
    
      
      
      user_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
      },
      user_name: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      date_of_pirth: {
        type: Sequelize.DATE,
        allowNull: false,
      },
      email: {
        type: Sequelize.STRING,
        allowNull: false,
        unique:true,
        validate:{isEmail:true,},
      },
      phone_number: {
        type: Sequelize.INTEGER,
        allowNull: false,
        unique:true,
      },
      permission: {
        type: Sequelize.STRING,
        allowNull: false,
        defaultValue:'student',
        validate:{
          isIn:[['student','teacher','admin','staff']],},
        },
        password: {
          type: Sequelize.STRING,
          allowNull: false,
          validate:{
            len: [8,100]},
        },
        description: {
          type: Sequelize.STRING,
          allowNull: true,
        },

      
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('users');
  }
};