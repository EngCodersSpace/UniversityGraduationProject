'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('assignment_attachments', {

      assignment_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'assignments',
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
    await queryInterface.addConstraint('assignment_attachments', {
      fields: ['assignment_id', 'attachment'],
      type: 'primary key',
      name: 'assignment_attachment_pkey',
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('assignment_attachments');
  }
};