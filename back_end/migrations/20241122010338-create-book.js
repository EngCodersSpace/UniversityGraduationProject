'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('books', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      title: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      author: {
        type: Sequelize.STRING,
        allowNull: true,
      },
      numberOfPages: {
        type: Sequelize.INTEGER,
        allowNull: true,
      },
      edition: {
        type: Sequelize.STRING(50),
        allowNull: true,
      },
      category:{
        type:Sequelize.ENUM('Reference','Lecture','ExamForm'),
        allowNull:false,
      },
      file_size: {
        type: Sequelize.FLOAT,
        allowNull: true,
      },
      file_path:{
        type:Sequelize.TEXT,
        allowNull:true,
      },
      display_image: {
        type: Sequelize.STRING,
        allowNull: true,
      },
      added_by: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'users',
          key: 'user_id',
        },
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
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


      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
    await queryInterface.addConstraint('books', {
      fields: ['title', 'numberOfPages', 'author', 'edition'],
      type: 'unique',
      name: 'unique_constraint_in_book',
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('books');
  }
};