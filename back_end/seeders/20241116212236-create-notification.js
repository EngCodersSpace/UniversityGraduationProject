"use strict";

const { faker } = require("@faker-js/faker");
const { user, notification } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Fetch all users (to use their IDs as sender_id)
    const users = await user.findAll();
    const topics  = buildConditions({ sections, levels, roles, targets }, 100);
    
    const notifications = [];
    const now = new Date();
    const startOfWeek = new Date(now);
    startOfWeek.setDate(now.getDate() - (now.getDay() === 0 ? 6 : now.getDay() - 1));
    startOfWeek.setHours(0, 0, 0, 0);
    const endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate() + 6);
    endOfWeek.setHours(23, 59, 59, 999);

  
    for (let i = 0; i < 10; i++) {
      const date = faker.date.between({ from: startOfWeek, to: endOfWeek });
      const sender = faker.helpers.arrayElement(users); // Randomly select a user as the sender
      const receiver = faker.helpers.arrayElement(users); // Randomly select a user as the sender
      notifications.push({
        sender_id: sender.user_id, // Associate sender_id with a user
        receiver_id: receiver.user_id,
        title: faker.company.catchPhrase(), // Generate a random title
        message: faker.lorem.sentences(3), // Generate a random message
        type:"single",
        createdAt: date,
        updatedAt: date,
      });
    }
    for (let i = 0; i < 100; i++) {
      const date2 = faker.date.between({ from: startOfWeek, to: endOfWeek });
      const sender = faker.helpers.arrayElement(users); // Randomly select a user as the sender
      notifications.push({
        sender_id: sender.user_id, // Associate sender_id with a user
        topic_name:topics[i],
        title: faker.company.catchPhrase(), // Generate a random title
        message: faker.lorem.sentences(3), // Generate a random message
        type:"single",
        createdAt: date2,
        updatedAt: date2,
      });

      const date3 = faker.date.between({ from: startOfWeek, to: endOfWeek });
      notifications.push({
        sender_id: sender.user_id, // Associate sender_id with a user
        topic_name:"all",
        title: faker.company.catchPhrase(), // Generate a random title
        message: faker.lorem.sentences(3), // Generate a random message
        type:"single",
        createdAt: date3,
        updatedAt: date3,
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
const sections = ["'section_1' in topic", "'section_2' in topic", "'section_3' in topic", "'section_4' in topic"];
const levels = ["level_1 'in' topic", "'level_2' in topic", "'level_3' in topic", "'level_4' in topic", "'level_5' in topic"];
const roles = ["'role_1' in topic", "'role_2' in topic", "'role_3' in topic", "'role_4' in topic", "'role_5' in topic"];
const targets = ["'student' in topic", "'doctor' in topic", "'student' in topic || 'doctor' in topic"];

