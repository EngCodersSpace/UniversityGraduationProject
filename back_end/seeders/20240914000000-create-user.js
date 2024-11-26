const { faker } = require('@faker-js/faker');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const users = [];
    for (let i = 0; i < 10; i++) {
      users.push({
        user_id: i + 1,
        user_name: faker.person.fullName(),
        date_of_birth: faker.date.past(30),
        profile_picture: faker.internet.url(),
        email: faker.internet.email(),
        permission: faker.helpers.arrayElement(['student', 'teacher', 'admin', 'staff']),
        password: faker.internet.password(),
        resetToken: faker.internet.url(),
        resetTokenExpiry: faker.date.future(),
        refreshToken: faker.internet.url(),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
    await queryInterface.bulkInsert('users', users);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('users', null, {});
  },
};
