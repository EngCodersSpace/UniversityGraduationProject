'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('news', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      publisher_id: {
        type: Sequelize.INTEGER,
        allowNull:false,
        references: {
          model: 'users' ,
          key:'user_id',
        },
        onDelete:'NO ACTION',
        onUpdate:'CASCADE',  
      },
      title:{
        type:Sequelize.STRING,
        allowNull:false,
      },
      content:{
        type:Sequelize.TEXT,
        allowNull:false,
      },
      time:{
        type: Sequelize.DATEONLY,
        allowNull: false,
        defaultValue: Sequelize.NOW,
      },
      image:{
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
    await queryInterface.dropTable('news');
  }
};