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
        onDelete: 'CASCADE',//if a user is delete the student associated with him will be deleted
        onUpdate: 'CASCADE',//if a user is update the student associated with him will be updated
      },
      study_plan_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'study_plans',
          key: 'study_plan_id',
        },
        onDelete: 'SET NULL',//if a study_plan is delete the student associated with him will be set null in the study_plan_id
        onUpdate: 'CASCADE',//if a study_plan is update the student associated with him will be updated
      },
      student_section: {
        type: Sequelize.ENUM('Computer', 'Communications', 'Civil', 'Architecture'),
        allowNull: false,
      },
      student_level_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'levels',
          key: 'id',
        },
        onDelete: 'CASCADE',
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
      profile_picture: {
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
    await queryInterface.dropTable('students');
  }
};