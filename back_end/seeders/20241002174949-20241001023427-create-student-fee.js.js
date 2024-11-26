'use strict';

const { faker } = require('@faker-js/faker');
const { student_fee, student } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const students = await student.findAll();

    const studentFees = students.map(stud => ({
      student_id: stud.student_id, 
      level_fees: faker.helpers.arrayElement(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5']),
      term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
      section: stud.student_section, 
      total_amount: faker.number.int({ min: 1000, max: 5000 }).toFixed(2), 
      amount_paid: faker.number.int({ min: 0, max: 5000 }).toFixed(2), 
      remaining_amount: faker.number.int({ min: 0, max: 5000 }).toFixed(2), 
      payment_status: faker.helpers.arrayElement(['Paid', 'Unpaid', 'Remaining']),
      payment_date: faker.datatype.boolean() ? faker.date.past() : null,
      receipt_number: faker.string.alphanumeric(10),
      createdAt: new Date(),
      updatedAt: new Date(),
    }));

    
    await student_fee.bulkCreate(studentFees);
  },

  down: async (queryInterface, Sequelize) => {
   
    await queryInterface.bulkDelete('student_fees', null, {});
  }
};
