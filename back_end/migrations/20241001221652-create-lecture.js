'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('lectures', {
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
      lecture_section: {
        type: Sequelize.ENUM('Computer', 'Communications', 'Civil', 'Architecture'),
        allowNull: false,
      },
      lecture_level: {
        type: Sequelize.ENUM('Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5',),
        allowNull: false,
      },
      term: {
        type: Sequelize.ENUM('Term 1', 'Term 2'),
        allowNull: false,
      },
      year: {
        type: Sequelize.STRING(30),
        allowNull: false,
      },
      lecture_time: {
        type: Sequelize.TIME,
        allowNull: false,
      },
      lecture_duration: {
        type: Sequelize.STRING(50),
        allowNull: false,
      },
      lecture_day: {
        type: Sequelize.ENUM('Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'),
        allowNull: false,
      },
      lecture_room: {
        type: Sequelize.STRING(50),
        allowNull: false,
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
    await queryInterface.addConstraint('lectures', {
      fields: ['lecture_time', 'lecture_day', 'lecture_section', 'lecture_room'],
      type: 'unique',
      name: 'unique_constraint_in_lecture',

    });


  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('lectures');
  }
};