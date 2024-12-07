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
      // status: {
      //   type: Sequelize.STRING,
      //   allowNull: true,
      // },
      academic_degree: {
        type: Sequelize.JSON,
        allowNull: false,
      },
      administrative_position: {
        type: Sequelize.JSON,
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