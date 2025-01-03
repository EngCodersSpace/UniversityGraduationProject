

"use strict";

const { faker } = require("@faker-js/faker");
const { user, subject, book } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Fetch all users and subjects to associate with books
    const users = await user.findAll();
    const subjects = await subject.findAll();

    const books = [];
    for (let i = 0; i < 20; i++) {
      const addedByUser = faker.helpers.arrayElement(users); // Randomly select a user as the book creator
      const subjectData = faker.helpers.arrayElement(subjects); // Randomly select a subject

      books.push({
        title: faker.lorem.words(5), // Generate a random title
        author: faker.person.fullName(), // Generate a random author name
        isbn: faker.string.uuid(), // Generate a random ISBN
        edition: faker.helpers.arrayElement(["1st", "2nd", "3rd", "Revised"]), // Random edition
        category: faker.helpers.arrayElement([
          "Reference",
          "Lecture",
          "ExamForm",
        ]), // Random category
        file_size: faker.number.float({ min: 0.5, max: 20, precision: 0.1 }), // Random file size in MB
        file_path: faker.system.filePath(), // Generate a random file path
        display_image: faker.image.url(300, 300, "abstract", true), // Generate a random image URL
        added_by: addedByUser.user_id, // Associate with a random user
        subject_id: subjectData.subject_id, // Associate with a random subject
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    // Bulk insert all book records
    await book.bulkCreate(books);
  },

  down: async (queryInterface, Sequelize) => {
    // Remove all books when rolling back
    await book.destroy({ where: {}, truncate: false });
  },
};