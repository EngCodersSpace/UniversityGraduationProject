"use strict";

const { faker } = require("@faker-js/faker");
const {
  assignment,
  subject,
  doctor,
  section,
  level,
  study_plan_elment,
} = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const subjects = await study_plan_elment.findAll();
    const years = ["2020", "2021", "2022", "2023", "2024", "2025"];
    const assignments = [];

    for (let i = 0; i < subjects.length; i++) {
      for (let y = 0; y < years.length; y++) {
        for (let j = 0; j < faker.number.int({ min: 3, max: 6 }); j++) {
          assignments.push({
            subject_id: subjects[i].subject_id,
            doctor_id: subjects[i].doctor_id,
            section_id: subjects[i].section_id,
            level_id: subjects[i].level_id,
            title: faker.helpers.arrayElement([
              { en: "assignment", ar: "تكليف" },
              { en: "task", ar: "مهمة" },
              { en: "project", ar: "مشروع" },
              { en: "exam", ar: "اختبار" },
              { en: "report", ar: "تقرير" },
            ]),
            assignment_due_day: faker.helpers.arrayElement([
              "Saturday",
              "Sunday",
              "Monday",
              "Tuesday",
              "Wednesday",
              "Thursday",
            ]),
            assignment_date: faker.date.past(),
            assignments_due_date: faker.date.future(),
            // year:faker.date.future().getFullYear(),
            year: years[y],
            createdAt: new Date(),
            updatedAt: new Date(),
          });
        }
      }
    }

    for (let i = 0; i < assignments.length; i += 1000) {
      const chunk = assignments.slice(i, i + 1000);
      await assignment.bulkCreate(chunk);
    }
  },

  down: async (queryInterface, Sequelize) => {
    await assignment.destroy({ where: {}, truncate: false });
  },
};
