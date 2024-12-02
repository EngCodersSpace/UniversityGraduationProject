'use strict';

const { faker } = require('@faker-js/faker');
const { subject, level, section } = require('../models'); 

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Fetch all levels and sections from the database
    const levels = await level.findAll();
    const sections = await section.findAll();

    // An object mapping each section to its relevant subject names
    const subjectNames = {
      'Electronics': [
        'Digital Circuits',
        'Analog Circuits',
        'Signal Processing',
        'Microcontrollers',
        'Embedded Systems'
      ],
      'Mechanical': [
        'Thermodynamics',
        'Fluid Mechanics',
        'Machine Design',
        'Dynamics',
        'Manufacturing Processes'
      ],
      'Civil': [
        'Structural Analysis',
        'Geotechnical Engineering',
        'Environmental Engineering',
        'Construction Management',
        'Transportation Engineering'
      ],
      'Computer Science': [
        'Data Structures',
        'Algorithms',
        'Operating Systems',
        'Computer Networks',
        'Database Management Systems'
      ]
    };

    const subjects = [];

    // Iterate to create subjects for each level and each corresponding section
    for (const levelItem of levels) {
      for (const sectionItem of sections) {
        const branchSubjects = subjectNames[sectionItem.section_name]; // Get the relevant subjects for the stream
        
        // Only create subjects if branch subjects exist
        if (branchSubjects) {
          for (const term of ['Term 1', 'Term 2']) { // Loop through terms
            for (let i = 0; i < branchSubjects.length; i++) {
              subjects.push({
                subject_id: `SUB-${levelItem.level_id}-${sectionItem.section_id}-${term.charAt(0)}`, // Unique subject_id
                subject_name: branchSubjects[i],
                number_of_units: Math.floor(Math.random() * 5) + 1, // Randomly assign units (1-5)
                subject_description: `This course covers fundamental concepts in ${branchSubjects[i]}.`,
                level_id: levelItem.level_id, // Associate subject with level
                section_id: sectionItem.section_id, // Associate subject with section
                term: term, // The current term
                createdAt: new Date(),
                updatedAt: new Date(),
              });
            }
          }
        }
      }
    }

    // Bulk create all subjects
    await subject.bulkCreate(subjects);
  },

  down: async (queryInterface, Sequelize) => {
    // Remove all subject entries for rollback
    await subject.destroy({ where: {}, truncate: true });
  }
};