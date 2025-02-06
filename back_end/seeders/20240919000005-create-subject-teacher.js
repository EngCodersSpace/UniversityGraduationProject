"use strict";

const { faker } = require("@faker-js/faker");
const { doctor, subject, subject_teacher } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Fetch all doctors, subjects, and levels
    const doctors = await doctor.findAll();
    const subjects = await subject.findAll();


    if (!subjects.length || !doctors.length) {
      throw new Error('no subjects or doctors ');
    }


    const subject_teachers = [];



    for (let i = 0; i < 20; i++) {
      const doctorData = faker.helpers.arrayElement(doctors);
      const subjectData = faker.helpers.arrayElement(subjects);

      // دالة للتحقق من التكرار
      const exists = (doctor_id,subject_id,subject_teachers)=>{
        return subject_teachers.some(
          (entry) =>
            entry.doctor_id === doctor_id &&
            entry.subject_id === subject_id
        );
      };
      

      // التحقق من التكرار قبل إضافة السجل
      if (!exists(doctorData.doctor_id, subjectData.subject_id, subject_teachers)) {
       
        subject_teachers.push({
          doctor_id: doctorData.doctor_id, 
          subject_id: subjectData.subject_id,
          createdAt:new Date(),
          updatedAt:new Date(),
        });
      }
    }
    
    // Bulk insert all subject_teacher records
    await subject_teacher.bulkCreate(subject_teachers);
  },

  down: async (queryInterface, Sequelize) => {
    // Remove all subject_teacher records when rolling back
    await subject_teacher.destroy({ where: {}, truncate: false });
  },
};




