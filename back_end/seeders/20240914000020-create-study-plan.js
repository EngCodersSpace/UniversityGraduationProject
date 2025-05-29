"use strict";

const { faker } = require("@faker-js/faker");
const { study_plan } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const val = [
          "Architecture_2025",
          "Computer_2025",
          "Communication_2025",
          "Civil_2025",
        ]
     const studyPlans = [];
    for (let i = 0; i < 4; i++) {
      studyPlans.push({
        study_plan_id: i + 1,
        study_plan_name: val[i],
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await study_plan.bulkCreate(studyPlans);
  },

  down: async (queryInterface, Sequelize) => {
    await study_plan.destroy({ where: {}, truncate: false });
  },
};
