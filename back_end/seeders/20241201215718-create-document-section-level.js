"use strict";

const { faker } = require("@faker-js/faker");
const { document, section, level, documentSectionLevel } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Fetch all documents, sections, and levels
    const documents = await document.findAll();
    const sections = await section.findAll();
    const levels = await level.findAll();

    const documentSectionLevels = [];

    // دالة للتحقق من التكرار
    const isDuplicate = (documentId, sectionId, levelId, documentSectionLevels) => {
      return documentSectionLevels.some(
        (entry) =>
          entry.documentId === documentId &&
          entry.sectionId === sectionId &&
          entry.levelId === levelId
      );
    };

    for (let i = 0; i < 20; i++) {
      const documentData = faker.helpers.arrayElement(documents);
      const sectionData = faker.helpers.arrayElement(sections);
      const levelData = faker.helpers.arrayElement(levels);

      // التحقق من التكرار قبل إضافة السجل
      if (!isDuplicate(documentData.id, sectionData.id, levelData.id, documentSectionLevels)) {
        documentSectionLevels.push({
          documentId: documentData.id, // Randomly associate with a document
          sectionId: sectionData.id, // Randomly associate with a section
          levelId: levelData.id, // Randomly associate with a level
        });
      }
    }

    // Bulk insert all documentSectionLevel records
    await documentSectionLevel.bulkCreate(documentSectionLevels);
  },

  down: async (queryInterface, Sequelize) => {
    // Remove all documentSectionLevel records when rolling back
    await documentSectionLevel.destroy({ where: {}, truncate: false });
  },
};




