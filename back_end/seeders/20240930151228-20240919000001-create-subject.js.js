const { faker } = require('@faker-js/faker');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const subjects = [];
    for (let i = 0; i < 10; i++) {
      subjects.push({
        subject_id: (i + 1).toString(), // Ensure correct ID type
        subject_name: faker.lorem.words(2),
        number_of_units: faker.number.int({ min: 1, max: 5 }),
        subject_description: faker.lorem.sentence(),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
    await queryInterface.bulkInsert('subjects', subjects);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('subjects', null, {});
  },
};
