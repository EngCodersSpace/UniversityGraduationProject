'use strict';

//const { faker } = require('@faker-js/faker');
const { role } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const roles = [
      {
        id:1,
        roleName:'Dean',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        id:2,
        roleName:'Controller',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        id:3,
        roleName:'Instructor',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        id:4,
        roleName:'Student Representative',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        id:5,
        roleName:'Student',
        createdAt: new Date(),
        updatedAt: new Date(),
      },

    ];


    
    await role.bulkCreate(roles);
  },

  down: async (queryInterface, Sequelize) => {
    await role.destroy({ where: {}, truncate: false });
  }
};
