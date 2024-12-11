"use strict";

const { faker } = require("@faker-js/faker");
const { user, student, study_plan, level,section} = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const users = await user.findAll(); // Get all users
    const studyPlans = await study_plan.findAll(); // Get all study plans
    const levels = await level.findAll(); // Get all levels
    const sections = await section.findAll();

    const students = [];
    for (let i = 0; i < 10; i++) {
      const usr = users[i];
      // Prepare student data based on user and related data
      students.push({
        student_id: i+1, // Associating student with the corresponding user
        study_plan_id: studyPlans[i % studyPlans.length].study_plan_id, // Select study plan cyclically
        student_name: faker.person.fullName(), // Fake student name
        enrollment_year: faker.date.past(5).getFullYear(), // Get only the year
        student_level_id: levels[i % levels.length].id, // Assign level cyclically
        student_system: faker.helpers.arrayElement([
          "General",
          "Free Seat",
          "Paid",
        ]), // Randomly assign a student system
        user: {
          user_id: i + 1,
          user_name: faker.person.fullName(),
          user_section_id: sections[i % sections.length].id,
          date_of_birth: faker.date.past(20),
          profile_picture: faker.internet.url(),
          email: faker.internet.email(),
          password: 12345678,
          collegeName: faker.helpers.arrayElement([
            "Engineering",
            "Science",
            "Business",
            "Arts",
          ]),
          permission: faker.helpers.arrayElement([
            "student",
            "teacher",
            "admin",
            "staff",
          ]),
        },
        createdAt: new Date(), // Set creation date
        updatedAt: new Date(), // Set updated date
      });
    }

    // Bulk insert all student records
    await student.bulkCreate(students, {
      include: [
        {
          model: user,
          as: "user", // تأكد من وضع الاسم الصحيح للنموذج
        },
      ],
    });
  },

  down: async (queryInterface, Sequelize) => {
    // Clean up the student data when rolling back
    await student.destroy({ where: {}, truncate: false });
    await user.destroy({ where: {}, truncate: false });
  },
};
