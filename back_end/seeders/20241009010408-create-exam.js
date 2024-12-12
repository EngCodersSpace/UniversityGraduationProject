'use strict';

const { faker } = require('@faker-js/faker');
const { exam, subject, section, level } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const subjects = await subject.findAll();
    const levels = await level.findAll();
    const sections = await section.findAll();

    const exams = [];
    const examYear = 2024;
    const startDate = new Date(examYear, 0, 1); // بداية السنة
    const examSchedule = {}; // لتتبع مواعيد الامتحانات لكل قسم ومستوى

    for (const section of sections) {
      for (const level of levels) {
        let currentDate = new Date(startDate); // إعادة ضبط التاريخ لكل مستوى
        for (const subject of subjects) {
          const sectionLevelKey = `${section.id}-${level.id}`;

          // ضمان أن نفس القسم والمستوى لا يختبرون أكثر من مادة في نفس اليوم
          if (!examSchedule[sectionLevelKey]) {
            examSchedule[sectionLevelKey] = [];
          }

          // تحقق من وجود مادة أخرى في نفس اليوم
          while (examSchedule[sectionLevelKey].includes(currentDate.toISOString().split('T')[0])) {
            currentDate.setDate(currentDate.getDate() + 1); // الانتقال لليوم التالي
          }

          // تحديد بيانات الامتحان
          exams.push({
            subject_id: subject.subject_id,
            exam_section_id: section.id,
            exam_level_id: level.id,
            exam_term: faker.helpers.arrayElement(['Term 1', 'Term 2']),
            exam_year: examYear,
            exam_date: currentDate.toISOString().split('T')[0],
            exam_time: faker.date.future(1, currentDate).toISOString().split('T')[1].slice(0, 8),
            exam_day: currentDate.toLocaleString('en-US', { weekday: 'long' }),
            exam_room: `Hall ${Math.floor(Math.random() * 100) + 1}`,
            createdAt: new Date(),
            updatedAt: new Date(),
          });

          // إضافة التاريخ المجدول لهذا القسم والمستوى
          examSchedule[sectionLevelKey].push(currentDate.toISOString().split('T')[0]);

          // الانتقال لليوم التالي لتجنب تعارض التواريخ
          currentDate.setDate(currentDate.getDate() + 1);
        }
      }
    }

    await exam.bulkCreate(exams);
  },
  

  down: async (queryInterface, Sequelize) => {
    await exam.destroy({ where: {}, truncate: false });
  }
};



