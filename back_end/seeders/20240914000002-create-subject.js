'use strict';

const { faker } = require('@faker-js/faker');
const { subject } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // An array of logical subject names
    const subjectNames = [
      'Mathematics',
      'Physics',
      'Chemistry',
      'Biology',
      'Computer Science',
      'Literature',
      'History',
      'Geography',
      'Economics',
      'Philosophy'
    ];

    const subjects = [];
    
    // Iterating to create subjects
    for (let i = 0; i < subjectNames.length; i++) {
      subjects.push({
        subject_id: `SUB${i + 1}`,
        subject_name: subjectNames[i],  // Using predefined logical subject names
        number_of_units: Math.floor(Math.random() * 5) + 1,  // Keep the same random number of units
        subject_description: `This course covers fundamental concepts in ${subjectNames[i]}.`, // Meaningful descriptions
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    await subject.bulkCreate(subjects);
  },

  down: async (queryInterface, Sequelize) => {
    await subject.destroy({ where: {}, truncate: true });
  }
};