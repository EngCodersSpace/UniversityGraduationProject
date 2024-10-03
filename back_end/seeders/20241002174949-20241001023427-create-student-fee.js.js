'use strict';
const { faker } = require('@faker-js/faker');

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    // Function to get existing IDs
    async function getExistingIds(queryInterface) {
      const [students] = await queryInterface.sequelize.query('SELECT student_id FROM students');
      return {
        studentIds: students.map(student => student.student_id),
      };
    }

    // Get existing student IDs
    const { studentIds } = await getExistingIds(queryInterface);

    const studentFees = [];
    for (let i = 0; i < 100; i++) {
      const randomStudentId = faker.helpers.arrayElement(studentIds); // Randomly select a student ID
      studentFees.push({
        student_id: randomStudentId,
        level_fees: faker.helpers.arrayElement(['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5']),
        term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
        section: faker.helpers.arrayElement(['Computer', 'Communications', 'Civil', 'Architecture']),
        total_amount: faker.finance.amount(1000, 5000, 2),
        amount_paid: faker.finance.amount(0, 5000, 2),
        remaining_amount: faker.finance.amount(0, 5000, 2),
        payment_status: faker.helpers.arrayElement(['Paid', 'Unpaid', 'Remaining']),
        payment_date: faker.datatype.boolean() ? faker.date.past() : null,
        receipt_number: faker.string.uuid(), // Use string.uuid instead
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await queryInterface.bulkInsert('student_fees', studentFees);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('student_fees', null, {});
  }
};
