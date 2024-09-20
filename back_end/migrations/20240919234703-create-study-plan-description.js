'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('study_plan_descriptions', {
      study_plan_description_id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      study_plan_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'study_plans',
          key: 'study_plan_id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },
      subject_id: {
        type: Sequelize.STRING,
        allowNull: false,
        references: {
          model: 'subjects',
          key: 'subject_id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },
      section: {
        type: Sequelize.ENUM('Computer', 'Communications', 'Civil', 'Architecture'),
        allowNull: false,
      },
      level: {
        type: Sequelize.ENUM('Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5',),
        allowNull: false,
      },
      number_of_units: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      term: {
        type: Sequelize.ENUM('Term 1', 'Term 2'),
        allowNull: false,
      },
      prerequisites:{
        type:Sequelize.STRING,
        allowNull:true,
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
    await queryInterface.dropTable('study_plan_descriptions');
  }
};