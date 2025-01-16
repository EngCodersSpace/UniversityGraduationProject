'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('assignment_files', {

      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
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
      attachment_hash:{
        type:Sequelize.STRING(64),
        allowNull:false,
      }



    });
    await queryInterface.addConstraint('assignment_files', {
      fields: ['assignment_id', 'attachment_hash'],
      type: 'unique',
      name: 'assignment_file_unique',
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('assignment_files');
  }
};