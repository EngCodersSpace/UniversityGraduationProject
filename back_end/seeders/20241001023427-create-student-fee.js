'use strict';

const { faker } = require('@faker-js/faker');
const { student_fee, student, section, level } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {

    const students = await student.findAll();
    const sections = await section.findAll();
    const levels = await level.findAll();

    const studentFees = [];

    for (let i = 0; i < 20; i++) {
      studentFees.push({
        student_id: students[i % students.length].student_id,
        level_fees_id: levels[i % levels.length].id,
        term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        section_id: sections[i % sections.length].id,
        total_amount: faker.number.int({ min: 1000, max: 5000 }).toFixed(2),
        amount_paid: faker.number.int({ min: 0, max: 5000 }).toFixed(2),
        remaining_amount: faker.number.int({ min: 0, max: 5000 }).toFixed(2),
        payment_status: faker.helpers.arrayElement(['Paid', 'Unpaid', 'Remaining']),
        payment_date: faker.datatype.boolean() ? faker.date.past() : null,
        receipt_number: faker.string.alphanumeric(10),
        createdAt: new Date(),
        updatedAt: new Date(),
      });

    }
    await student_fee.bulkCreate(studentFees);
  },

  down: async (queryInterface, Sequelize) => {

    await student_fee.destroy({ where: {}, truncate: false });
  },
};
