'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('subjects', {
      subject_id: {
        allowNull: false,
        primaryKey: true,
        type: Sequelize.STRING(10),
      },
      subject_name: {
        type: Sequelize.STRING
      },
      number_of_units:{
        type:Sequelize.INTEGER,
        allowNull:false,
      },
      subject_description:{
        type: Sequelize.TEXT,
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
    await queryInterface.dropTable('subjects');
  }
};