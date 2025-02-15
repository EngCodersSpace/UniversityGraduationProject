'use strict';
const { faker } = require('@faker-js/faker');
const { student_assignment_file, student_assignment } = require('../models');
const crypto = require('crypto');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const studentAssignments = await student_assignment.findAll();

    const student_assignment_files = [];

    for (const studentAssignment of studentAssignments) {
      
      const numberOfAttachments = faker.number.int({ min: 1, max: 3 }); 

      for (let i = 0; i < numberOfAttachments; i++) {
        const attachmentUrl = faker.internet.url(); 
        const originalName = faker.system.fileName(); 
        const attachmentHash = crypto.createHash('sha256').update(attachmentUrl).digest('hex'); 

        student_assignment_files.push({
          student_assignment_id: studentAssignment.id, 
          attachment: attachmentUrl, 
          attachment_hash: attachmentHash, 
          original_name: originalName, 
        });
      }
    }

    
    const chunkSize = 500;
    for (let i = 0; i < student_assignment_files.length; i += chunkSize) {
      const chunk = student_assignment_files.slice(i, i + chunkSize);

      await student_assignment_file.bulkCreate(chunk);
    }

  },

  down: async (queryInterface, Sequelize) => {
    
    await student_assignment_file.destroy({ where: {}, truncate: false });
  }
};


