"use strict";

const { faker } = require("@faker-js/faker");
const { user, doctor, section } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Fetch all users from the database
    const users = await user.findAll();
    const sections = await section.findAll();

    const doctors = [];
    for (let i = 50; i < 55; i++) {
      doctors.push({
        doctor_id: i + 1, // Associate doctor with the corresponding user
        // status: faker.helpers.arrayElement(['Active', 'Inactive']), // Randomly assign status
        academic_degree: faker.helpers.arrayElement([
          {
            en: "Doctor",
            ar: "دكتور",
          },
          {
            en: "Professor",
            ar: "بروفسور",
          },
          {
            en: "Master",
            ar: "ماجستير",
          },
          {
            en: "Bachelor",
            ar: "باكالوريس",
          },
        ]), // Assign academic degree
        administrative_position: faker.helpers.arrayElement([
          {
            en: "Dean",
            ar: "عميد",
          },
          {
            en: "Vice Dean",
            ar: "نائب العميد",
          },
          {
            en: "Lecturer",
            ar: "محاضر",
          },
          {
            en: "Department Chair",
            ar: "رئيس قسم",
          },
          {
            en: "None",
            ar: "لا شئ",
          },
        ]),
        user:{
          user_id: i + 1,
          user_name: faker.person.fullName(),
          user_section_id: sections[i % sections.length].id,
          date_of_birth: faker.date.past(20),
          profile_picture: faker.internet.url(),
          email: faker.internet.email(),
          password: 12345678,
          collegeName: faker.helpers.arrayElement(['Engineering', 'Science', 'Business', 'Arts']),
          permission: faker.helpers.arrayElement(['student', 'teacher', 'admin', 'staff']),
          createdAt: new Date(),
          updatedAt: new Date(),
        }, // Assign position
        createdAt: new Date(), // Set creation date
        updatedAt: new Date(), // Set updated date
      });
    }
    // Bulk insert all doctor records into the database
    await doctor.bulkCreate(doctors,{
      include: [{
        model: user,
        as: 'user' // تأكد من وضع الاسم الصحيح للنموذج
    }]
    });
  },

  down: async (queryInterface, Sequelize) => {
    // Remove all doctor records when rolling back
    await doctor.destroy({ where: {}, truncate: false });
  },
};
