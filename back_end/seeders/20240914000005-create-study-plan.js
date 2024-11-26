const { faker } = require('@faker-js/faker');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const studyPlans = [];
    for (let i = 0; i < 5; i++) {
      studyPlans.push({
        study_plan_id: i + 1,
        study_plan_name: faker.lorem.words(3),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
    await queryInterface.bulkInsert('study_plans', studyPlans);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('study_plans', null, {});
  },
};
