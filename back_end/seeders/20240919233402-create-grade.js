'use strict';

const { faker } = require('@faker-js/faker');
const { grade, student, subject, section, level } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {

    const students = await student.findAll();
    const subjects = await subject.findAll();
    const sections = await section.findAll();
    const levels = await level.findAll();
    const statusOptions = [
      { en: "Freshman", ar: "مستجد" },
      { en: "Repeater", ar: "مُعيد" },
    ];

    const grades = [];

    for (let i = 0; i < students.length; i++) {
      const studentData = students[i];
      const sectionData = faker.helpers.arrayElement(sections);
      const levelData = faker.helpers.arrayElement(levels);

      for (let j = 0; j < subjects.length; j++) {
        const subjectData = subjects[j];
        const selectedStatus = faker.helpers.arrayElement(statusOptions);

        grades.push({
          student_id: studentData.student_id,
          subject_id: subjectData.subject_id,
          exam_grade: faker.number.int({ min: 0, max: 70 }),
          work_grade: faker.number.int({ min: 0, max: 30 }),
          term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
          section_id: sectionData.id,
          level_id: levelData.id,
          year_of_issue: faker.date.past({ years: 3 }).toISOString().split("T")[0],
          is_absent: faker.datatype.boolean(),
          status: {
            en:selectedStatus.en,
            ar: selectedStatus.ar,
          },
          createdAt: new Date(),
          updatedAt: new Date(),
        });
      }
    }

    await grade.bulkCreate(grades);
  },

  down: async (queryInterface, Sequelize) => {

    await grade.destroy({ where: {}, truncate: false });
  }
};
