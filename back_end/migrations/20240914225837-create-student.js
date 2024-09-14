'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('students', {
      
      student_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        references: {
          model:'users',
          key:'user_id',
        },
        
      },
      student_name: {
        type: Sequelize.STRING,
      },
      student_section: {
        type: Sequelize.STRING,
        validate:{
          isIn:[['Computer','Communications','Civil','Architecture']],},
      },
      enrollment_year: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      student_level: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      status: {
        type: Sequelize.STRING,
        allowNull: false,

      },
      address: {
        type: Sequelize.STRING,
        allowNull: true,
      },
      gender: {
        type: Sequelize.STRING,
        allowNull: false,
        validate:{
          isIn:[['Male','Female']],},
        
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
    await queryInterface.dropTable('students');
  }
};