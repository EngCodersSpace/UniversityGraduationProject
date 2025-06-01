"use strict";

const { faker } = require("@faker-js/faker");
const { study_plan } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const val = [
          "2024-2025",
          "2023-2024",
          "2022-2023",
          "2021-2022",
        ]
     const studyPlans = [];
    for (let i = 0; i < val.length; i++) {
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
