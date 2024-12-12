"use strict";

const { faker } = require("@faker-js/faker");
const { user, notification } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Fetch all users (to use their IDs as sender_id)
    const users = await user.findAll();

    const notifications = [];
    for (let i = 0; i < 20; i++) {
      const sender = faker.helpers.arrayElement(users); // Randomly select a user as the sender
      notifications.push({
        sender_id: sender.user_id, // Associate sender_id with a user
        title: faker.company.catchPhrase(), // Generate a random title
        message: faker.lorem.sentences(3), // Generate a random message
        is_read: faker.datatype.boolean(), // Randomly assign read status
        type: faker.helpers.arrayElement(["System", "Reminder", "Alert"]), // Random notification type
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    // Bulk insert all notifications
    await notification.bulkCreate(notifications);
  },

  down: async (queryInterface, Sequelize) => {
    // Remove all notifications when rolling back
    await notification.destroy({ where: {}, truncate: false });
  },
};
