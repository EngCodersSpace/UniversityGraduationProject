"use strict";

const { faker } = require("@faker-js/faker");
const { doctor, subject, subject_teacher } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const doctors = await doctor.findAll();
    const subjects = await subject.findAll();

    if (!subjects.length || !doctors.length) {
      throw new Error("No subjects or doctors found");
    }

    const subject_teachers = [];

    // Helper to check duplicates
    const exists = (doctorId, subjectId) => {
      return subject_teachers.some(
        (entry) =>
          entry.doctor_id === doctorId && entry.subject_id === subjectId
      );
    };

    // 1) Ensure each subject has at least one doctor
    for (const subjectItem of subjects) {
      const randomDoctor = faker.helpers.arrayElement(doctors);
      subject_teachers.push({
        doctor_id: randomDoctor.doctor_id,
        subject_id: subjectItem.subject_id,
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    // 2) Add more random assignments, avoiding duplicates
    // For example, add 1-3 more random doctors per subject
    for (const subjectItem of subjects) {
      const numberOfExtraDoctors = faker.number.int({ min: 1, max: 3 });

      for (let i = 0; i < numberOfExtraDoctors; i++) {
        const randomDoctor = faker.helpers.arrayElement(doctors);

        if (!exists(randomDoctor.doctor_id, subjectItem.subject_id)) {
          subject_teachers.push({
            doctor_id: randomDoctor.doctor_id,
            subject_id: subjectItem.subject_id,
            createdAt: new Date(),
            updatedAt: new Date(),
          });
        }
      }
    }

    await subject_teacher.bulkCreate(subject_teachers);
  },

  down: async (queryInterface, Sequelize) => {
    await subject_teacher.destroy({ where: {}, truncate: false });
  },
};
