+"use strict";

const { faker } = require("@faker-js/faker");
const { lecture, subject, doctor, section, level } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
  
    const subjects = await subject.findAll();
    const doctors = await doctor.findAll();
    const sections = await section.findAll();
    const levels = await level.findAll();

    const lectures = [];
    const days = [
      "Saturday",
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
    ];
    const terms = ["Term 1", "Term 2"];
    //داله للتحقق من التكرار
    const isDuplicateLecture = (lecture, lectures) => {
      return lectures.some(
        (l) =>
          l.lecture_time === lecture.lecture_time &&
          l.lecture_day === lecture.lecture_day &&
          l.lecture_section_id === lecture.lecture_section_id &&
          l.lecture_room === lecture.lecture_room
      );
    };


    for (let s = 0; s < sections.length; s++) {
      for (let l = 0; l < levels.length; l++) {
        for (let t = 0; t < 2; t++) {
          for (let d = 0; d < days.length; d++) {
            for (let i = 0; i < faker.number.int({ min: 1, max: 3 }); i++) {
              const randomHour = faker.number.int({ min: 8, max: 17 });
              const randomMinute = faker.number.int({
                min: 0,
                max: 59,
                multipleOf: 15,
              });
              const lectureTime = `${randomHour
                .toString()
                .padStart(2, "0")}:${randomMinute.toString().padStart(2, "0")}`;
              const n = faker.number.int({ min: 0, max: subjects.length });
              const lecture = {
                subject_id: subjects[faker.number.int({ min: 0, max: subjects.length - 1 })].subject_id,
                doctor_id: doctors[faker.number.int({ min: 0, max: doctors.length - 1 })].doctor_id,
                lecture_section_id: sections[s].id,
                lecture_level_id: levels[l].id,
                term: terms[t],
                year: faker.date.past().getFullYear(),
                lecture_time: lectureTime,
                lecture_duration: faker.number.int({
                  min: 60,
                  max: 180,
                  multipleOf: 60,
                }),
                lecture_day: days[d],
                lecture_room: `Hall ${faker.number.int({ min: 1, max: 100 })}`,
                isReplaced: false,
                createdAt: new Date(),
                updatedAt: new Date(),
              };
              //منع التكرار قبل اضافة محاظرة
              if (!isDuplicateLecture(lecture, lectures)) {
                lectures.push(lecture);
              }


            }
          }
        }
      }
    }

    await lecture.bulkCreate(lectures);
  },

  down: async (queryInterface, Sequelize) => {
    await lecture.destroy({ where: {}, truncate: false });
  },
};