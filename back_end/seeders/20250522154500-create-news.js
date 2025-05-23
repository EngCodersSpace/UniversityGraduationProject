'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.bulkInsert('news', [
      {
        publisher_id: 1,
        title: 'Smart Lab Launched in Electrical Engineering Department',
        content: `The Faculty of Engineering has officially inaugurated the new Smart Lab within the Department of Electrical Engineering.
Equipped with cutting-edge simulation and control systems, the lab aims to enhance students' practical skills and project experience.
It includes advanced technologies for automation, embedded systems, and power electronics.
The inauguration ceremony was attended by the Dean, faculty members, and students.
This initiative reflects the faculty’s commitment to modernizing the academic environment.
Students will now have access to hands-on tools for research and innovation.
The lab also supports graduation projects and interdisciplinary learning.
Faculty members praised the potential of the lab to bridge the gap between theory and practice.
The Dean emphasized continued investment in smart infrastructure.
Future workshops and training sessions will be held regularly in the lab.`,
        time: '2025-05-10 10:00',
        image: 'https://images.pexels.com/photos/3183165/pexels-photo-3183165.jpeg',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        publisher_id: 1,
        title: 'Renewable Energy Workshop for Electrical Engineering Students',
        content: `The Faculty of Engineering organized a technical workshop on “The Future of Renewable Energy.”
Targeted at electrical engineering students, the session explored solar and wind power systems.
Industry experts presented real-world applications and market trends in sustainable energy.
Students were encouraged to develop innovative solutions for local energy challenges.
The workshop featured live demonstrations and project exhibitions by student teams.
Discussions included job opportunities in green technology sectors.
Participants showed great interest and interacted actively during Q&A sessions.
All attendees received participation certificates at the end of the event.
Top-performing student teams were recognized for their creativity.
The faculty plans to conduct similar workshops each semester.`,
        time: '2025-04-25 14:00',
        image: 'https://images.pexels.com/photos/257736/pexels-photo-257736.jpeg',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        publisher_id: 1,
        title: 'Final-Year Project Defense Schedule Announced',
        content: `The Faculty of Engineering has announced the official schedule for final-year project defenses.
Presentations will take place from Monday, June 10, to Thursday, June 13, in the engineering halls.
All graduating students are required to prepare their slides and follow academic guidelines.
Evaluation panels will consist of faculty members and external academic reviewers.
Students must wear formal attire and arrive at least 15 minutes before their session.
The defense sessions will cover a wide range of engineering disciplines and topics.
Each presentation will be followed by a Q&A and evaluation.
The detailed timetable will be published on the faculty’s official website and notice boards.
Students are encouraged to rehearse and consult their supervisors in advance.
This marks a critical milestone in every student’s academic journey.`,
        time: '2025-05-20 09:00',
        image: 'https://images.pexels.com/photos/1181359/pexels-photo-1181359.jpeg',
        createdAt: new Date(),
        updatedAt: new Date()
      }
    ], {});
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('news', null, {});
  }
};
