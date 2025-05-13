'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('student_assignment_files', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      student_assignment_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'student_assignments',
          key: 'id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },
      attachment: {
        type: Sequelize.TEXT,
        allowNull: false,
      },
      attachment_hash:{
        type:Sequelize.STRING(64),
        allowNull:false,
      },
      original_name:{
        type:Sequelize.STRING,
        allowNull:false
      },
    });

  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('student_assignment_files');
  }
};