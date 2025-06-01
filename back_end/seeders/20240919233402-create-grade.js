"use strict";
const { faker } = require("@faker-js/faker");
const {
  grade,
  student,
  user,
  study_plan_elment,
} = require("../models");
const { Model } = require("firebase-admin/machine-learning");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const students = await student.findAll({
      include: [
        {
          model: user,
          as: "user",
        },
      ],
    });
    const statusOptions = [
      { en: "Freshman", ar: "?????" },
      { en: "Repeater", ar: "?????" },
    ];

    const grades = [];

    for (let i = 0; i < students.length; i++) {
      const studyPlanElement = await study_plan_elment.findAll({
        where: {
          study_plan_id: students[i].study_plan.study_plan_id,
          section_id: students[i].user.user_section_id,
        },
      });
      if (!studyPlanElement) {
        console.log(
          `Skipping student ${students[i].student_id}: No stud plan element.`
        );
        continue;
      }
      for (let j = 0; j < studyPlanElement.length; j++) {
          grades.push({
          student_id: students[i].student_id,
          subject_id: studyPlanElement[j].subject_id,
          exam_grade: faker.number.int({min:30,max:70}),
          work_grade: faker.number.int({min:10,max:30}),
          term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
          section_id: studyPlanElement[j].section_id,
          level_id: studyPlanElement[j].level_id, // taken from the study plan element
          year_of_issue: new Date().toISOString().split('T')[0], // yyyy-mm-dd format
          is_absent: false,
          status: faker.helpers.arrayElement(statusOptions),
          createdAt: new Date(),
          updatedAt: new Date()
        });
      }
    }

    for (let i = 0; i < grades.length; i += 1000) {
      const chunk = grades.slice(i, i + 1000);
      await grade.bulkCreate(chunk);
    }

    console.log(`Seed data inserted into grades table successfully.`);
  },

  down: async (queryInterface, Sequelize) => {
    await grade.destroy({ where: {}, truncate: false });
  },
};
