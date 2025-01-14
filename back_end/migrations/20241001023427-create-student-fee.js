'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('student_fees', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      student_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'students',
          key: 'student_id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },
      section_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'sections',
          key: 'id',
        },
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
      },
      level_fees_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'levels',
          key: 'id',
        },
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
      },
      term: {
        type: Sequelize.ENUM('Term 1', 'Term 2'),
        allowNull: false,
      },
      total_amount: {
        type: Sequelize.DECIMAL(8, 2),
        allowNull: false,
      },
      amount_paid: {
        type: Sequelize.DECIMAL(8, 2),
        allowNull: false,
      },
      remaining_amount: {
        type: Sequelize.DECIMAL(8, 2),
        allowNull: false,
      },
      payment_status: {
        type: Sequelize.ENUM('Paid', 'Unpaid', 'Remaining'),
        allowNull: false,
      },
      payment_date: {
        type: Sequelize.DATE,
        allowNull: true,
      },
      receipt_number: {
        type: Sequelize.STRING,
        allowNull: false,
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
    await queryInterface.dropTable('student_fees');
  }
};