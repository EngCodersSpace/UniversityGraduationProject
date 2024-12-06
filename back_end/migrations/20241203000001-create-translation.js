'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('translations', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      tableName: {
        type: Sequelize.STRING(100),
        allowNull: false,
      },
      recordId: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      field: {
        type: Sequelize.STRING(100),
        allowNull:false,
      },
      languageId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references:{
          model:'languages',
          key:'id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },
      value:{
        type:Sequelize.STRING(100),
        allowNull:false,
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      },

    });
    await queryInterface.addIndex('translations',{
      unique:false,
      fields:['tableName','recordId','field','languageId'],
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('translations');
  }
};