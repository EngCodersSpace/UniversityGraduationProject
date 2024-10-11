const { faker } = require('@faker-js/faker');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const doctors = [];
    const userIds = await getExistingIds(queryInterface);

    for (const userId of userIds) {
      doctors.push({
        doctor_id: userId, 
        doctor_name: faker.person.fullName(),
        department: faker.commerce.department(),
        status: faker.helpers.arrayElement(['Active', 'Inactive']),
        academic_degree: faker.helpers.arrayElement(['Doctor', 'Professor', 'Master', 'Bachelor']),
        administrative_position: faker.helpers.arrayElement(['Dean', 'Vice Dean', 'Lecturer', 'Department Chair', 'None']),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await queryInterface.bulkInsert('doctors', doctors);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('doctors', null, {});
  },
};

async function getExistingIds(queryInterface) {
  const [results] = await queryInterface.sequelize.query('SELECT user_id FROM users');
  return results.map(user => user.user_id);
}
