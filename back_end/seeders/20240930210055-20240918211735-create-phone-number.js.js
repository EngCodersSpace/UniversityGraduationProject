const { faker } = require('@faker-js/faker');

async function getExistingIds(queryInterface) {
  const [users] = await queryInterface.sequelize.query('SELECT user_id FROM users');

  return {
    userIds: users.map(user => user.user_id),
  };
}

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const existingIds = await getExistingIds(queryInterface);
    const phoneNumbers = [];

    for (let i = 0; i < 10; i++) {
      phoneNumbers.push({
        phone_number: faker.phone.number(),
        user_id: existingIds.userIds[i % existingIds.userIds.length], 
        
      });
    }
    await queryInterface.bulkInsert('phone_numbers', phoneNumbers);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('phone_numbers', null, {});
  },
};
