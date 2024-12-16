"use strict";

const { faker } = require("@faker-js/faker");
const { book, section, level, bookSectionLevel } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Fetch all books, sections, and levels
    const books = await book.findAll();
    const sections = await section.findAll();
    const levels = await level.findAll();

    const bookSectionLevels = [];

    // دالة للتحقق من التكرار
    const isDuplicate = (bookId, sectionId, levelId, bookSectionLevels) => {
      return bookSectionLevels.some(
        (entry) =>
          entry.bookId === bookId &&
          entry.sectionId === sectionId &&
          entry.levelId === levelId
      );
    };

    for (let i = 0; i < 20; i++) {
      const bookData = faker.helpers.arrayElement(books);
      const sectionData = faker.helpers.arrayElement(sections);
      const levelData = faker.helpers.arrayElement(levels);

      // التحقق من التكرار قبل إضافة السجل
      if (!isDuplicate(bookData.id, sectionData.id, levelData.id, bookSectionLevels)) {
        bookSectionLevels.push({
          bookId: bookData.id, // Randomly associate with a book
          sectionId: sectionData.id, // Randomly associate with a section
          levelId: levelData.id, // Randomly associate with a level
        });
      }
    }

    // Bulk insert all bookSectionLevel records
    await bookSectionLevel.bulkCreate(bookSectionLevels);
  },

  down: async (queryInterface, Sequelize) => {
    // Remove all bookSectionLevel records when rolling back
    await bookSectionLevel.destroy({ where: {}, truncate: false });
  },
};




