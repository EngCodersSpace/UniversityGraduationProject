'use strict';
const { faker } = require('@faker-js/faker');
const { student_assignment, student, assignment } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const students = await student.findAll();
    const assignments = await assignment.findAll();

    const studentAssignments = [];

    
    for (const studentItem of students) {
      
      const numberOfAssignments = faker.number.int({ min: 1, max: assignments.length });

      for (let i = 0; i < numberOfAssignments; i++) {
        const assignmentItem = assignments[faker.number.int({ min: 0, max: assignments.length - 1 })];

        
        studentAssignments.push({
          student_id: studentItem.student_id,
          assignment_id: assignmentItem.id,
          status: faker.datatype.boolean(), 
        });
      }
    }

    
    if (studentAssignments.length > 0) {
      await student_assignment.bulkCreate(studentAssignments);
    }
  },

  down: async (queryInterface, Sequelize) => {
    
    await student_assignment.destroy({ where: {}, truncate: false });
  }
};


