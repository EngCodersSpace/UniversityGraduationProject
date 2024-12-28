'use strict';
const { faker } = require('@faker-js/faker');
const { student, student_fee } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Get all students with their corresponding user data
    const students = await student.findAll({include:[{ association: 'level',},{association: 'study_plan',}],attributes:['student_id','student_level_id','student_system']});


    const studentFees = [];

    // Loop through students
    for (const studentData of students) {
      const studentId = studentData.student_id;
      const currentLevelId = studentData.student_level_id; // Current level of the student
      const system = JSON.parse(studentData.student_system); // System type (Paid or not)


      // Loop through levels from level 1 to the student's current level
      for (let levelIndex = 1; levelIndex <= currentLevelId; levelIndex++) {
        // Loop through terms (Term 1, Term 2)
        for (let termIndex = 1; termIndex <= 2; termIndex++) {
          const term = `Term ${termIndex}`;
          

          if (system.en === 'Paid' || system.ar === 'موازي') {
            // Paid students logic (can pay once or twice in each term)
            const numberOfInstallments = faker.number.int({ min: 1, max: 2 }); // Randomly decide 1 or 2 installments
            let installments = [];

            if (numberOfInstallments === 1) {
              // Single payment installment
              installments = [500];
            } else {
              // Two installments
              const firstInstallment = faker.number.float({ min: 100, max: 400 }); // Random first installment
              const secondInstallment = 500 - firstInstallment; // Remaining amount
              installments = [firstInstallment, secondInstallment];
            }

            // Create fee records for each installment
            for (let installment of installments) {
              const feeData1 = {
                student_id: studentId,
                level_fees_id: levelIndex, // Representing the level (not linked to the levels table)
                term: term,
                total_amount: 500,
                amount_paid: installment,
                remaining_amount: 500 - installment, // Remaining amount after payment
                payment_date: faker.date.past(1), // Random past date
                receipt_number: faker.string.uuid(),
                createdAt: new Date(),
                updatedAt: new Date(),
              };
              studentFees.push(feeData1);
            }
          } else {
            // Non-Paid students logic (one payment of 100 per term)
            const feeData = {
              student_id: studentId,
              level_fees_id: levelIndex, // Representing the level (not linked to the levels table)
              term: term,
              total_amount: 100,
              amount_paid: 100,
              remaining_amount: 0, // Fully paid
              payment_date: faker.date.past(1), // Random past date
              receipt_number: faker.string.uuid(),
              createdAt: new Date(),
              updatedAt: new Date(),
            };
            studentFees.push(feeData);
          }
        }
      }
    }

    // Insert student fees into the database
    if (studentFees.length > 0) {
      await student_fee.bulkCreate(studentFees);
    }
    
  },

  down: async (queryInterface, Sequelize) => {
    // Clean up student fees data when rolling back
    await student_fee.destroy({ where: {}, truncate: false });
  },
};


