"use strict";

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.bulkInsert(
      "news",
      [
        {
          publisher_id: 1,
          title: "Smart Lab Launched in Electrical Engineering Department",
          content: JSON.stringify([
            { insert: "Smart Lab Inauguration\n", attributes: { header: 2 } },

            { insert: "• " },
            {
              insert: "The Faculty of Engineering",
              attributes: { bold: true },
            },
            {
              insert:
                " has officially inaugurated the new Smart Lab within the Department of Electrical Engineering.\n",
            },

            { insert: "• " },
            {
              insert:
                "Equipped with cutting-edge simulation and control systems",
              attributes: { bold: true },
            },
            {
              insert:
                ", the lab aims to enhance students' practical skills and project experience.\n",
            },

            { insert: "• It includes advanced technologies for " },
            {
              insert: "automation, embedded systems, and power electronics",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• The inauguration ceremony was attended by the " },
            {
              insert: "Dean, faculty members, and students",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• " },
            {
              insert: "This initiative reflects the faculty’s commitment",
              attributes: { bold: true },
            },
            { insert: " to modernizing the academic environment.\n" },

            { insert: "• Students will now have access to " },
            {
              insert: "hands-on tools for research and innovation",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• The lab also supports " },
            {
              insert: "graduation projects and interdisciplinary learning",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            {
              insert: "• Faculty members praised the potential of the lab to ",
            },
            {
              insert: "bridge the gap between theory and practice",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• The Dean emphasized " },
            {
              insert: "continued investment in smart infrastructure",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• Future " },
            {
              insert: "workshops and training sessions",
              attributes: { bold: true },
            },
            { insert: " will be held regularly in the lab.\n" },
          ]),
          time: "2025-05-10 10:00",
          image:
            "https://images.pexels.com/photos/3183165/pexels-photo-3183165.jpeg",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          publisher_id: 1,
          title:
            "Renewable Energy Workshop for Electrical Engineering Students",
          content: JSON.stringify([
            {
              insert:
                "Renewable Energy Workshop for Electrical Engineering Students\n",
              attributes: { header: 2 },
            },

            { insert: "• " },
            {
              insert: "The Faculty of Engineering",
              attributes: { bold: true },
            },
            {
              insert:
                " organized a technical workshop on “The Future of Renewable Energy.”\n",
            },

            { insert: "• Targeted at " },
            {
              insert: "electrical engineering students",
              attributes: { bold: true },
            },
            {
              insert: ", the session explored solar and wind power systems.\n",
            },

            { insert: "• " },
            { insert: "Industry experts", attributes: { bold: true } },
            {
              insert:
                " presented real-world applications and market trends in sustainable energy.\n",
            },

            { insert: "• Students were encouraged to " },
            {
              insert:
                "develop innovative solutions for local energy challenges",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• The workshop featured " },
            {
              insert: "live demonstrations and project exhibitions",
              attributes: { bold: true },
            },
            { insert: " by student teams.\n" },

            { insert: "• Discussions included " },
            {
              insert: "job opportunities in green technology sectors",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• Participants showed " },
            {
              insert:
                "great interest and interacted actively during Q&A sessions",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• All attendees received " },
            {
              insert: "participation certificates",
              attributes: { bold: true },
            },
            { insert: " at the end of the event.\n" },

            {
              insert:
                "• Top-performing student teams were recognized for their ",
            },
            { insert: "creativity", attributes: { bold: true } },
            { insert: ".\n" },

            { insert: "• The faculty plans to conduct " },
            {
              insert: "similar workshops each semester",
              attributes: { bold: true },
            },
            { insert: ".\n" },
          ]),
          image:
            "https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          publisher_id: 1,
          title: "Final-Year Project Defense Schedule Announced",
          content: JSON.stringify([
            {
              insert: "Final-Year Project Defense Schedule Announcement\n",
              attributes: { header: 2 },
            },

            { insert: "• " },
            {
              insert: "The Faculty of Engineering",
              attributes: { bold: true },
            },
            {
              insert:
                " has announced the official schedule for final-year project defenses.\n",
            },

            { insert: "• Presentations will take place from " },
            {
              insert: "Monday, June 10, to Thursday, June 13",
              attributes: { bold: true },
            },
            { insert: ", in the engineering halls.\n" },

            { insert: "• All graduating students are required to " },
            {
              insert: "prepare their slides and follow academic guidelines",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• Evaluation panels will consist of " },
            {
              insert: "faculty members and external academic reviewers",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• Students must wear " },
            {
              insert:
                "formal attire and arrive at least 15 minutes before their session",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• The defense sessions will cover a " },
            {
              insert: "wide range of engineering disciplines and topics",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• Each presentation will be followed by a " },
            { insert: "Q&A and evaluation", attributes: { bold: true } },
            { insert: ".\n" },

            { insert: "• The detailed timetable will be published on the " },
            {
              insert: "faculty’s official website and notice boards",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• Students are encouraged to " },
            {
              insert: "rehearse and consult their supervisors in advance",
              attributes: { bold: true },
            },
            { insert: ".\n" },

            { insert: "• This marks a " },
            {
              insert: "critical milestone in every student’s academic journey",
              attributes: { bold: true },
            },
            { insert: ".\n" },
          ]),
          image:
            "https://images.pexels.com/photos/1181359/pexels-photo-1181359.jpeg",
          createdAt: new Date(),
          updatedAt: new Date(),
        },
      ],
      {}
    );
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete("news", null, {});
  },
};
