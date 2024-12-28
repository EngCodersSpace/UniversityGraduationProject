'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('subject_teachers', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },

      subject_id: {
        type: Sequelize.STRING(10),
        allowNull: false,
        references: {
          model: 'subjects',
          key: 'subject_id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },
      doctor_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'doctors',
          key: 'doctor_id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
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
    await queryInterface.dropTable('subject_teachers');
  }
};