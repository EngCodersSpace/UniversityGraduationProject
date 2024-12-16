'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('bookSectionLevels', {
    
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      bookId:{
        type:Sequelize.INTEGER,
        allowNull:false,
        references:{
          model:'books',
          key:'id',
        },
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
      },
      sectionId:{
        type:Sequelize.INTEGER,
        allowNull:false,
        references:{
          model:'sections',
          key:'id',
        },
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
      },
      levelId:{
        type:Sequelize.INTEGER,
        allowNull:false,
        references:{
          model:'levels',
          key:'id',
        },
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
      },


    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('bookSectionLevels');
  }
};