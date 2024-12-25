
'use strict';

const { faker } = require('@faker-js/faker');
const { user, student, doctor, study_plan, level, section } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const studyPlans = await study_plan.findAll(); // Get all study plans
    const levels = await level.findAll(); // Get all levels
    const sections = await section.findAll(); // Get all sections

    const users = [];
    const students = [];
    const doctors = [];

    for (let i = 0; i < 100; i++) {
      // Generate fake data

      //user
      const college = faker.helpers.arrayElement([
        { en: 'Engineering', ar: 'الهندسة' },
        { en: 'Science', ar: 'العلوم' },
        { en: 'Business', ar: 'الأعمال' },
        { en: 'Arts', ar: 'الفنون' },
      ]);


      const userName = faker.person.fullName();
      const userNameLocalized = {
        en: userName,
        ar: userName.split(' ').reverse().join(' '), // عكس الاسم كطريقة عشوائية لترجمته
      };
      const permissionn = faker.helpers.arrayElement(['student', 'representative', 'dean', 'vice_dean', 'controller', 'department_head', 'lecturer', 'student_affairs', 'general_secretary']);
      const userData = {
        user_id: i + 1,
        user_name: userNameLocalized, // Assign user name in JSON format
        user_section_id: sections[i % sections.length].id,
        date_of_birth: faker.date.past(20),
        profile_picture: faker.internet.url(),
        email: faker.internet.email(),
        password: '12345678',
        collegeName: college, // Assign college name in JSON format
        permission: permissionn,
        createdAt: new Date(),
        updatedAt: new Date(),
      };

      users.push(userData);

      // Add student or doctor data based on permission
      if (['student', 'representative'].includes(permissionn)) {
        const system = faker.helpers.arrayElement(["General", "Free Seat", "Paid"]);
        const translatedSystem = system === "General" ? "عام" : system === "Free Seat" ? "مقعد مجاني" : "موازي";

        students.push({
          student_id: i + 1, // Associating student with the corresponding user
          study_plan_id: studyPlans[i % studyPlans.length].study_plan_id, // Select study plan cyclically
          enrollment_year: faker.date.past(5).getFullYear(), // Get only the year
          student_level_id: levels[i % levels.length].id, // Assign level cyclically
          student_system: {
            en: system,
            ar: translatedSystem
          },
          createdAt: new Date(),
          updatedAt: new Date(),
        });
      } else if (['dean', 'vice_dean', 'controller', 'department_head', 'lecturer', 'student_affairs', 'general_secretary'].includes(permissionn)) {
        const academicDegree = faker.helpers.arrayElement([
          { en: 'Doctor', ar: 'دكتور' },
          { en: 'Professor', ar: 'بروفسور' },
          { en: 'Master', ar: 'ماجستير' },
          { en: 'Bachelor', ar: 'بكالوريوس' },
        ]);
        const administrativePosition = faker.helpers.arrayElement([
          { en: 'Dean', ar: 'عميد' },
          { en: 'Vice Dean', ar: 'نائب العميد' },
          { en: 'Lecturer', ar: 'محاضر' },
          { en: 'Department Chair', ar: 'رئيس قسم' },
          { en: 'None', ar: 'لا شيء' },
        ]);
        doctors.push({
          doctor_id: i + 1, // Associate doctor with the corresponding user
          academic_degree: academicDegree, // Assign academic degree in JSON format
          administrative_position: administrativePosition, // Assign administrative position in JSON format

          createdAt: new Date(),
          updatedAt: new Date(),
        });
      }
    }

    // Insert users
    await user.bulkCreate(users);

    // Insert students
    if (students.length > 0) {
      await student.bulkCreate(students);
    }

    // Insert doctors
    if (doctors.length > 0) {
      await doctor.bulkCreate(doctors);
    }
  },

  down: async (queryInterface, Sequelize) => {
    // Clean up the data when rolling back
    await student.destroy({ where: {}, truncate: false });
    await doctor.destroy({ where: {}, truncate: false });
    await user.destroy({ where: {}, truncate: false });
  },
};
