'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('assignments', {
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
      title: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      assignment_day: {
        type: Sequelize.ENUM('Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'),
        allowNull: false,
      },
      assignment_date: {
        type: Sequelize.DATE,
        allowNull: false,
      },
      assignments_due_date: {
        type: Sequelize.DATE,
        allowNull: false,
      },
      attachment: {
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
    await queryInterface.dropTable('assignments');
  }
};