"use strict";

const { faker } = require("@faker-js/faker");
const { user, notification } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Fetch all users (to use their IDs as sender_id)
    const users = await user.findAll();
    const topics  = buildConditions({ sections, levels, roles, targets }, 100);
    console.log(topics);
    const notifications = [];
    for (let i = 0; i < 10; i++) {
      const sender = faker.helpers.arrayElement(users); // Randomly select a user as the sender
      const receiver = faker.helpers.arrayElement(users); // Randomly select a user as the sender
      notifications.push({
        sender_id: sender.user_id, // Associate sender_id with a user
        receiver_id: receiver.user_id,
        title: faker.company.catchPhrase(), // Generate a random title
        message: faker.lorem.sentences(3), // Generate a random message
        type:"single",
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
    for (let i = 0; i < 100; i++) {
      const sender = faker.helpers.arrayElement(users); // Randomly select a user as the sender
      notifications.push({
        sender_id: sender.user_id, // Associate sender_id with a user
        topic_name:topics[i],
        title: faker.company.catchPhrase(), // Generate a random title
        message: faker.lorem.sentences(3), // Generate a random message
        type:"single",
        createdAt: new Date(),
        updatedAt: new Date(),
      });

      notifications.push({
        sender_id: sender.user_id, // Associate sender_id with a user
        topic_name:"all",
        title: faker.company.catchPhrase(), // Generate a random title
        message: faker.lorem.sentences(3), // Generate a random message
        type:"single",
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





function getRandomSubset(arr, min = 1) {
  const count = Math.floor(Math.random() * (arr.length - min + 1)) + min;
  const shuffled = arr.slice().sort(() => 0.5 - Math.random());
  return shuffled.slice(0, count);
}

function buildConditions({ sections, levels, roles, targets }, count = 10) {
  const results = [];

  for (let i = 0; i < count; i++) {
    // Pick random target
    const target = targets[Math.floor(Math.random() * targets.length)];
    const targetStr = target === "student" || target === "doctor"
      ? `(${target})`
      : "(student || doctor)";

    // Randomly decide which filters to include
    const useSections = Math.random() < 0.9;
    const useLevels = target !== "doctor" && Math.random() < 0.7;
    const useRoles = Math.random() < 0.8;

    const parts = [targetStr];

    if (useSections) {
      const selectedSections = getRandomSubset(sections);
      parts.push(`(${selectedSections.join(" || ")})`);
    }

    if (useLevels && target.includes("student")) {
      const selectedLevels = getRandomSubset(levels);
      parts.push(`(${selectedLevels.join(" || ")})`);
    }

    if (useRoles) {
      const selectedRoles = getRandomSubset(roles);
      parts.push(`(${selectedRoles.join(" || ")})`);
    }

    results.push(parts.join(" && "));
  }

  return results;
}

// Your data
const sections = ["section_1", "section_2", "section_3", "section_4"];
const levels = ["level_1", "level_2", "level_3", "level_4", "level_5"];
const roles = ["role_1", "role_2", "role_3", "role_4", "role_5"];
const targets = ["student", "doctor", "student || doctor"];

