'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('documents', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      title: {
        type: Sequelize.STRING,
        allowNull:false,
      },
      author:{
        type:Sequelize.STRING,
        allowNull:true,
      },
      isbn:{
        type:Sequelize.STRING(50),
        allowNull:true,
      },
      edition:{
        type:Sequelize.STRING(50),
        allowNull:true,
      },
      category:{
        type:Sequelize.ENUM('Book','Reference','Lecture','Summary','Exam','Other'),
        allowNull:false,
      },
      file_size:{
        type:Sequelize.FLOAT,
        allowNull:true,
      },
      file_path:{
        type:Sequelize.TEXT,
        allowNull:false,
      },
      display_image:{
        type:Sequelize.STRING,
        allowNull:true,
      },
      added_by:{
        type:Sequelize.INTEGER,
        allowNull:false,
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
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('documents');
  }
};