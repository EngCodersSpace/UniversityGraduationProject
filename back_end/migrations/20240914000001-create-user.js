'use strict';
const bcrypt = require('bcrypt');
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('users', {

      user_id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
      },
      user_name: {
        type: Sequelize.JSON,
        allowNull: false,
      },
      user_section_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'sections',
          key: 'id',
        },
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
      },
      date_of_birth: {
        type: Sequelize.DATE,
        allowNull: true,
      },
      profile_picture: {
        type: Sequelize.STRING,
        allowNull: true,
      },
      collegeName: {
        type: Sequelize.JSON,
        allowNull: false,
      },
      email: {
        type: Sequelize.STRING(100),
        allowNull: false,
        unique: true,
        validate: { isEmail: true, },
      },
      permission: {
        type: Sequelize.ENUM('student', 'teacher', 'admin', 'staff'),
        allowNull: false,
        defaultValue: 'student',
      },
      password: {
        type: Sequelize.STRING(100),
        allowNull: false,
        set(value) {
          const hasedpassword = bcrypt.hashSync(value, 10);
          this.setDataValue('password', hasedpassword);
        },
      },
      resetToken: {
        type: Sequelize.TEXT,
        allowNull: true,
      },
      resetTokenExpiry: {
        type: Sequelize.DATE,
        allowNull: true,
      },
      refreshToken: {
        type: Sequelize.TEXT,
        allowNull: true,
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
    await queryInterface.dropTable('users');
  }
};