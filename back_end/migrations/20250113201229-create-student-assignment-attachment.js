'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('student_assignment_attachments', {
      student_assignment_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'studstudent_assignmentsents',
          key: 'id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },
      attachment: {
        type: Sequelize.TEXT,
        allowNull: false,
      },
    });
    await queryInterface.addConstraint('student_assignment_attachments', {
      fields: ['student_assignment_id', 'attachment'],
      type: 'primary key',
      name: 'student_assignment_attachment_pkey',
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('student_assignment_attachments');
  }
};