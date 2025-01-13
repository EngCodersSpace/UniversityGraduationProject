'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('student_assignment_attachments', {
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
      }
    });
    await queryInterface.addConstraint('student_assignment_attachments', {
      fields: ['student_assignment_id', 'attachment_hash'],
      type: 'unique',
      name: 'student_assignment_attachment_unique',
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('student_assignment_attachments');
  }
};