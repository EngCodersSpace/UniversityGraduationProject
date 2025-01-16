'use strict';
const { faker } = require('@faker-js/faker');
const { student_assignment_file, student_assignment } = require('../models');
const crypto = require('crypto');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    
    const studentAssignments = await student_assignment.findAll();

    const studentAssignmentAttachments = [];

    for (const studentAssignment of studentAssignments) {
      
      const numberOfAttachments = faker.number.int({ min: 1, max: 3 }); 

      for (let i = 0; i < numberOfAttachments; i++) {
        const attachmentUrl = faker.internet.url(); 
        const attachmentHash = crypto.createHash('sha256').update(attachmentUrl).digest('hex'); 

        studentAssignmentAttachments.push({
          student_assignment_id: studentAssignment.id, 
          attachment: attachmentUrl, 
          attachment_hash: attachmentHash, 
        });
      }
    }

    
    if (studentAssignmentAttachments.length > 0) {
      await student_assignment_file.bulkCreate(studentAssignmentAttachments);
    }
  },

  down: async (queryInterface, Sequelize) => {
    
    await student_assignment_file.destroy({ where: {}, truncate: false });
  }
};


