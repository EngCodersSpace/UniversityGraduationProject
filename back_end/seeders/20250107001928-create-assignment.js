'use strict';

const { faker } = require('@faker-js/faker');
const { assignment, subject, doctor } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const subjects = await subject.findAll();
    const doctors = await doctor.findAll();

    const assignments = [];


    for (let i = 0; i < 50; i++) {
      const subjectItem = faker.helpers.arrayElement(subjects);
      const doctorItem = faker.helpers.arrayElement(doctors);


      // const titlee = faker.helpers.arrayElements(titleMap);
      // console.log('ddddd',titlee);

      const title = faker.helpers.arrayElement([
        { en: 'assignment', ar: 'تكليف', },
        { en: 'task', ar: 'مهمة', },
        { en: 'project', ar: 'مشروع', },
        { en: 'exam', ar: 'اختبار', },
        { en: 'report', ar: 'تقرير', },

      ]);

      assignments.push({
        subject_id: subjectItem.subject_id,
        doctor_id: doctorItem.doctor_id,
        title: title,
        assignment_due_day: faker.helpers.arrayElement(['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday']),
        assignment_date: faker.date.past(),
        assignments_due_date: faker.date.future(),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }


    await assignment.bulkCreate(assignments);
  },

  down: async (queryInterface, Sequelize) => {

    await assignment.destroy({ where: {}, truncate: false });
  }
};


