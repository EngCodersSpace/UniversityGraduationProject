'use strict';

//const { faker } = require('@faker-js/faker');
const { role, permission } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const data = [
      {
        id: 1,
        roleName: 'Dean',
        permissions: [
          ////////////lectures////////////////
          {
            target: 'lectures',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'lectures',
            action: 'accessOldTables',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          /////////////exams///////////
          {
            target: 'exams',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'exams',
            action: 'accessOldTables',
            createdAt: new Date(),
            updatedAt: new Date(),
          },

          ///////////////////////////assignments/////////
          {
            target: 'assignments',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'assignments',
            action: 'setCompletion',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'assignments',
            action: 'setStatus',
            createdAt: new Date(),
            updatedAt: new Date(),
          },


          {
            target: 'notification',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'sections',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'levels',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'study_plans',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'permissions',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'roles',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'users',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'subjects',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'students',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'phone_numbers',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'doctors',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'grades',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'study_plan_elments',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'prerequisites',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'student_fees',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'books',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'student_assignments',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
          {
            target: 'refresh_states',
            action: 'write',
            createdAt: new Date(),
            updatedAt: new Date(),
          },
        ],
        createdAt: new Date(),
        updatedAt: new Date(),
      },



      {
        id: 2,
        roleName: 'Controller',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        id: 3,
        roleName: 'Instructor',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        id: 4,
        roleName: 'Student Representative',
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        id: 5,
        roleName: 'Student',
        createdAt: new Date(),
        updatedAt: new Date(),
      },

    ];

    for (const record of data) {
      await role.create(record, {
        include: [permission],
      });
    }



    // await role.bulkCreate(roles);
  },

  down: async (queryInterface, Sequelize) => {
    await role.destroy({ where: {}, truncate: false });
    await permission.destroy({ where: {}, truncate: false });
  }
};
