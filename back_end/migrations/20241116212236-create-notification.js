'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('notifications', {
      message_id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      sender_id: {
        type: Sequelize.INTEGER,
        references: {
          model: 'users',
          key: 'user_id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },
      receiver_id: {
        type: Sequelize.INTEGER,
        allowNull:true,
      },
      topic_name: {
        type: Sequelize.STRING,
        allowNull:true,
      },
      title: {
        type: Sequelize.STRING(100)
      },
      message: {
        type: Sequelize.TEXT,
        allowNull:false,
      },
      type:{
        type:Sequelize.ENUM('single','topic','System'),
        defaultValue:'System',
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
    await queryInterface.dropTable('notifications');
  }
};