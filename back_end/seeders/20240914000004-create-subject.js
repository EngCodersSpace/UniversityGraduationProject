

"use strict";

const { faker, ar } = require("@faker-js/faker");
const { subject } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const subject_names = [
      { en: "Design Principles", ar: "مبادئ التصميم" },
      { en: "Fundamentals", ar: "الأساسيات" },
      { en: "Materials Science", ar: "علم المواد" },
      { en: "Fluid Mechanics", ar: "ميكانيكا الموائع" },
      { en: "Thermodynamics", ar: "الديناميكا الحرارية" },
      { en: "Control Systems", ar: "أنظمة التحكم" },
      { en: "Power Systems", ar: "أنظمة الطاقة" },
      { en: "Signal Processing", ar: "معالجة الإشارات" },
      { en: "Machine Learning", ar: "تعلم الآلة" },
      { en: "Project Management", ar: "إدارة المشاريع" },
      { en: "Renewable Energy", ar: "الطاقة المتجددة" },
      { en: "AI Integration", ar: "دمج الذكاء الاصطناعي" },
      { en: "Instrumentation", ar: "الأجهزة" },
      { en: "Embedded Systems", ar: "الأنظمة المدمجة" },
      { en: "Advanced Mechanics", ar: "الميكانيكا المتقدمة" },
      { en: "Finite Element Analysis", ar: "تحليل العناصر المحدودة" },
    ];

    const subjects = [];
    for (let i = 0; i < subject_names.length; i++) {
      subjects.push({
        subject_id: faker.lorem.slug(),
        subject_name: subject_names[i], 
        number_of_units: faker.number.int({min:2,max:3}),
        subject_description:{ 
          en:`This is the description for ${subject_names[i].en}.`,
          ar:`هذا الوصف ل ${subject_names[i].en}.`,
      },
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await subject.bulkCreate(subjects);
  },

  down: async (queryInterface, Sequelize) => {
    await subject.destroy({ where: {}, truncate: false });
  },
};
