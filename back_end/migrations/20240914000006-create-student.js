'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('students', {
      student_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        references: {
          model: 'users',
          key: 'user_id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },
      study_plan_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'study_plans',
          key: 'study_plan_id',
        },
        onDelete: 'SET NULL',
        onUpdate: 'CASCADE',
      },
      student_level_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'levels',
          key: 'id',
        },
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
      },
      enrollment_year: {
        type: Sequelize.DATEONLY,
        allowNull: false,
      },
      student_system: {
        type: Sequelize.ENUM('General', 'Free Seat', 'Paid'),
        allowNull: false,
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('students');
  },
};
