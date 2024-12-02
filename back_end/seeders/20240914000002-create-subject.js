'use strict';

const { faker } = require('@faker-js/faker');
const { subject } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const levels = await queryInterface.sequelize.query(
      "SELECT * FROM levels",
      { type: Sequelize.QueryTypes.SELECT }
    );
    const sections = await queryInterface.sequelize.query(
      "SELECT * FROM sections",
      { type: Sequelize.QueryTypes.SELECT }
    );

    if (!levels.length || !sections.length) {
      console.log('Levels or Sections not found, aborting seeding.');
      return;
    }

    const subjects = [];

    for (let level of levels) {
      for (let section of sections) {
        const subjectName = faker.lorem.word();
        subjects.push({
          subject_id: `${level.id}_${section.id}_${subjectName.replace(/\s+/g, '_')}`,
          subject_name: subjectName,
          number_of_units: Math.floor(Math.random() * 5) + 1,
          subject_description: `This is the description for ${subjectName} in Level ${level.name} Section ${section.name}.`,
          createdAt: new Date(),
          updatedAt: new Date(),
        });
      }
    }

    await subject.bulkCreate(subjects);
  },

  down: async (queryInterface, Sequelize) => {
    await subject.destroy({ where: {}, truncate: true });
  }
};