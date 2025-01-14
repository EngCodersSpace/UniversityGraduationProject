'use strict';

const { faker } = require('@faker-js/faker');
const { assignment_attachment, assignment } = require('../models');
const crypto = require('crypto');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const assignments = await assignment.findAll(); 
    const attachments = [];

    for (const assignmentItem of assignments) {
      const numberOfAttachments = faker.number.int({ min: 1, max: 3 }); 
      for (let i = 0; i < numberOfAttachments; i++) {
        const attachment = faker.internet.url(); 

        
        const attachmentHash = crypto.createHash('sha256').update(attachment).digest('hex');
        
        
        const existingAttachment = await assignment_attachment.findOne({
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
          });
        }
      }
    }

    
    if (attachments.length > 0) {
      await assignment_attachment.bulkCreate(attachments);
    }
  },

  down: async (queryInterface, Sequelize) => {
    
    await assignment_attachment.destroy({ where: {}, truncate: false });
  }
};


