'use strict';

const { faker } = require('@faker-js/faker');
const { assignment_file, assignment } = require('../models');
const crypto = require('crypto');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const assignments = await assignment.findAll(); 
    const attachments = [];

    for (const assignmentItem of assignments) {
      const numberOfAttachments = faker.number.int({ min: 1, max: 3 }); 
      for (let i = 0; i < numberOfAttachments; i++) {
        const attachment = faker.internet.url(); 
        const originalName = faker.system.fileName(); 
        const attachmentHash = crypto.createHash('sha256').update(attachment).digest('hex');
        
        
        const existingAttachment = await assignment_file.findOne({
          where: {
            assignment_id: assignmentItem.id,
            attachment_hash: attachmentHash
          }
        });

        if (!existingAttachment) {
          attachments.push({
            assignment_id: assignmentItem.id, 
            attachment, 
            attachment_hash: attachmentHash, 
            original_name: originalName,
          });
        }
      }
    }

    
    if (attachments.length > 0) {
      for (let i = 0; i < attachments.length; i += 1000) {
      const chunk = attachments.slice(i, i + 1000);
      await assignment_file.bulkCreate(chunk);
    }
    }
  },

  down: async (queryInterface, Sequelize) => {
    
    await assignment_file.destroy({ where: {}, truncate: false });
  }
};


