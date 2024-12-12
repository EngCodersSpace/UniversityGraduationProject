'use strict';

const { faker } = require('@faker-js/faker');
const { user, doctor, section } = require('../models');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Fetch all users and sections from the database
    const users = await user.findAll();
    const sections = await section.findAll();

    const doctors = [];
    for (let i = 50; i < 55; i++) {
      // Generate fake data
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

      doctors.push({
        doctor_id: i + 1, // Associate doctor with the corresponding user
        academic_degree: academicDegree, // Assign academic degree in JSON format
        administrative_position: administrativePosition, // Assign administrative position in JSON format
        user: {
          user_id: i + 1,
          user_name: userNameLocalized, // Assign user name in JSON format
          user_section_id: sections[i % sections.length].id,
          date_of_birth: faker.date.past(20),
          profile_picture: faker.internet.url(),
          email: faker.internet.email(),
          password: '12345678',
          collegeName: college, // Assign college name in JSON format
          permission: faker.helpers.arrayElement(['student', 'teacher', 'admin', 'staff']),
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        createdAt: new Date(), // Set creation date
        updatedAt: new Date(), // Set updated date
      });
    }

    // Bulk insert all doctor records into the database
    await doctor.bulkCreate(doctors, {
      include: [
        {
          model: user,
          as: 'user', // Ensure the correct model alias is used
        },
      ],
    });
  },

  down: async (queryInterface, Sequelize) => {
    // Remove all doctor records when rolling back
    await doctor.destroy({ where: {}, truncate: false });
  },
};