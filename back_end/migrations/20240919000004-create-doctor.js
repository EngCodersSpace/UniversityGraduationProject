'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('doctors', {
      doctor_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        references: {
          model: 'users' ,
          key:'user_id',
        },
        onDelete:'CASCADE',
        onUpdate:'CASCADE',  
      },
      department: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      status: {
        type: Sequelize.STRING,
        allowNull: true,
      },
      academic_degree: {
        type: Sequelize.ENUM('Doctor','Professor','Master','Bachelor'),
        allowNull: false,
      },
      administrative_position: {
        type: Sequelize.ENUM('Dean','Vice Dean','Lecturer','Department Chair','None'),
        defaultValue: 'None',
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
    await queryInterface.dropTable('doctors');
  }
};