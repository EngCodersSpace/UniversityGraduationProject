'use strict';
const { faker } = require('@faker-js/faker');

module.exports = {
  async up(queryInterface, Sequelize) {
    const { subjectIds, doctorIds } = await getExistingIds(queryInterface);
    const lectures = [];

    const sections = ['Computer', 'Communications', 'Civil', 'Architecture'];
    const levels = ['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'];
    const terms = ['Term 1', 'Term 2'];
    const days = ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];

    for (let i = 0; i < 50; i++) {
      const lectureDate = faker.date.future(); // Use a future date for the lecture
      const lectureTime = `${lectureDate.getHours().toString().padStart(2, '0')}:${lectureDate.getMinutes().toString().padStart(2, '0')}`; // Format time

      // Format year as "YYYY-MM-DD"
      const formattedDate = lectureDate.toLocaleDateString('en-CA'); // ISO format YYYY-MM-DD

      lectures.push({
        subject_id: faker.helpers.arrayElement(subjectIds),
        doctor_id: faker.helpers.arrayElement(doctorIds),
        lecture_section: faker.helpers.arrayElement(sections),
        lecture_level: faker.helpers.arrayElement(levels),
        term: faker.helpers.arrayElement(terms),
        year: formattedDate, // Use formatted date
        lecture_time: lectureTime, // Use formatted time
        lecture_duration: `${faker.number.int({ min: 1, max: 3 })} hours`, // Updated number generation
        lecture_day: faker.helpers.arrayElement(days),
        lecture_room: `${faker.location.street()} ${faker.number.int({ min: 100, max: 999 })}`, // Updated to use location
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await queryInterface.bulkInsert('lectures', lectures, {});
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('lectures', null, {});
  }
};

// Helper function to fetch existing IDs
async function getExistingIds(queryInterface) {
  const [subjects] = await queryInterface.sequelize.query('SELECT subject_id FROM subjects');
  const [doctors] = await queryInterface.sequelize.query('SELECT doctor_id FROM doctors');

  return {
    subjectIds: subjects.map(subject => subject.subject_id),
    doctorIds: doctors.map(doctor => doctor.doctor_id),
  };
}
