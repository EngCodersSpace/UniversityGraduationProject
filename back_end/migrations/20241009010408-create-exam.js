'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('exams', {
      exam_id: {
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
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
      },
      exam_section_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'sections',
          key: 'id',
        },
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
      },
      exam_level_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'levels',
          key: 'id',
        },
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
      },
      exam_term: {
        type: Sequelize.ENUM('Term 1', 'Term 2'),
        allowNull: false,
      },
      exam_year: {
        type: Sequelize.STRING(30),
        allowNull: false,
      },
      exam_date: {
        type: Sequelize.DATEONLY,
        allowNull: false,
      },
      exam_time: {
        type: Sequelize.TIME,
        allowNull: false,
      },
      exam_day: {
        type: Sequelize.ENUM('Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'),
        allowNull: false,
      },
      exam_room: {
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
    await queryInterface.addConstraint('exams', {
      fields: ['exam_section_id', 'exam_level_id', 'exam_term', 'exam_year', 'exam_date', 'exam_time', 'exam_day'],
      type: 'unique',
      name: 'unique_constraint_in_exam',

    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('exams');
  }
};