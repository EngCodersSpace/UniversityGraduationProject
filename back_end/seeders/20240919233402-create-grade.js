'use strict';
const { faker } = require('@faker-js/faker');
const { grade, student, subject, section, level, user } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {

    
    const students = await student.findAll();
    const subjects = await subject.findAll();
    const sections = await section.findAll();
    const levels = await level.findAll();
    const statusOptions = [
      { en: "Freshman", ar: "?????" },
      { en: "Repeater", ar: "?????" },
    ];

    const grades = [];

    for (let i = 0; i < students.length; i++) {
      const studentData = students[i];

      
      const userRecord = await user.findOne({
        where: { user_id: studentData.student_id }
      });

      
      if (!userRecord || !userRecord.user_section_id) {
        console.log(`Skipping student ${studentData.student_id}: No user or section found.`);
        continue;
      }

      const sectionData = await section.findOne({
        where: { id: userRecord.user_section_id }
      });

      
      if (!sectionData) {
        console.log(`Skipping student ${studentData.student_id}: No section found for section ID ${userRecord.user_section_id}.`);
        continue;
      }

      
      for (let levelIndex = 1; levelIndex <= 5; levelIndex++) {
        for (let j = 0; j < subjects.length; j++) {
          const subjectData = subjects[j];
          const selectedStatus = faker.helpers.arrayElement(statusOptions);

          grades.push({
            student_id: studentData.student_id,
            subject_id: subjectData.subject_id,
            exam_grade: faker.number.int({ min: 30, max: 70 }),
            work_grade: faker.number.int({ min: 15, max: 30 }),
            term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
            section_id: sectionData.id,
            level_id: levelIndex,
            year_of_issue: faker.date.past({ years: 3 }).toISOString().split("T")[0], 
            is_absent: faker.datatype.boolean(),
            status: {
              en: selectedStatus.en,
              ar: selectedStatus.ar,
            },
            createdAt: new Date(),
            updatedAt: new Date(),
          });
        }
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
  }
};


