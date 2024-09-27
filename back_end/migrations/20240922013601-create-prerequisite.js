'use strict';

const prerequisite = require('../models/prerequisite');

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('prerequisites', {
      id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
      },
      subject_id: {
        type: Sequelize.STRING(10),
        allowNull: true,
        references: {
          model: 'subjects',
          key: 'subject_id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },
      study_plan_elment_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'study_plan_elments',
          key: 'study_plan_elment_id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },

    });
    await queryInterface.addConstraint('prerequisites', {
      fields: ['study_plan_elment_id', 'subject_id'],
      type: 'unique',
      name: 'unique_constraint_in_study_plan_elment_id_and_subject_id',

    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('prerequisites');
  }
};