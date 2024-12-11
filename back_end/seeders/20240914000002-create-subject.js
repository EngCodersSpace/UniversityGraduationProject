'use strict';

const { faker } = require('@faker-js/faker');
const { subject } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const subject_names = [
      "Design Principles",
      "Fundamentals",
      "Materials Science",
      "Fluid Mechanics",
      "Thermodynamics",
      "Control Systems",
      "Power Systems",
      "Signal Processing",
      "Machine Learning",
      "Project Management",
      "Renewable Energy",
      "AI Integration",
      "Instrumentation",
      "Embedded Systems",
      "Advanced Mechanics",
      "Finite Element Analysis",
    ];

    const subjects = [];
    for (let i=0;i<subject_names.length; i++) {

        subjects.push({
          subject_id: faker.lorem.word(),
          subject_name: subject_names[i],
          number_of_units: Math.floor(Math.random() * 5) + 1,
          subject_description: `This is the description for ${subject_names[i]}.`,
          createdAt: new Date(),
          updatedAt: new Date(),
        });
    }
    await subject.bulkCreate(subjects);
  },

  down: async (queryInterface, Sequelize) => {
    await subject.destroy({ where: {}, truncate: false });
  }
};