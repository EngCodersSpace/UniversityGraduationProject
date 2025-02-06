
'use strict';

const { faker } = require('@faker-js/faker');
<<<<<<< HEAD:back_end/seeders/20240914000033-create-user.js
const { user, student, doctor, study_plan, level, section, role } = require('../models');
=======
const { user, student, doctor, study_plan, level, section } = require('../models');
>>>>>>> BackEnd:back_end/seeders/20240914000003-create-user.js
const bcrypt = require("bcrypt");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const studyPlans = await study_plan.findAll(); // Get all study plans
    const levels = await level.findAll(); // Get all levels
    const sections = await section.findAll(); // Get all sections
    const roles = await role.findAll();

    const users = [];
    const students = [];
    const doctors = [];

    for (let i = 0; i < 40; i++) {
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
    // const  rol = roles.find(r => r.roleName === 'Dean').id;
    //   console.log('roles:', rol);
      // const ro =
      //   i === 0
      //     ? roles.
      let rol
      if (i === 0) {
        rol = roles.find(r => r.roleName === 'Dean').id;
       // console.log('roles:',rol);
      } else if (i >= 1 && i < 20) {
        rol=faker.helpers.arrayElement([
          roles.find(r => r.roleName === 'Controller').id,
          roles.find(r => r.roleName === 'Instructor').id,
          
        ]);
       // console.log('roles 1 -20:',rol);
      } else if (i >= 20 && i < 25) {
        rol =roles.find(r => r.roleName === 'Student Representative').id;
       // console.log('roles 20 -25:',rol);
      } else {
        rol = roles.find(r => r.roleName === 'Student').id;
       // console.log('roles 25 -40:',rol);
      }
      const userData = {
        user_id: i + 1,
        user_name: userNameLocalized, // Assign user name in JSON format
        user_section_id: sections[i % sections.length].id,
        date_of_birth: faker.date.past(20),
        profile_picture: faker.internet.url(),
        email: faker.internet.email(),
        password: '1234pass@',
        collegeName: college, // Assign college name in JSON format
        roleId: rol,
        createdAt: new Date(),
        updatedAt: new Date(),
      };

      users.push(userData);

      // Add student or doctor data based on permission
      if (i < 20) {
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

      } else if (i < 40) {
        const system = faker.helpers.arrayElement([
          { en: 'General', ar: 'عام' },
          { en: 'Free Seat', ar: 'مقعد مجاني' },
          { en: 'Paid', ar: 'موازي' },
        ]);

        students.push({
          student_id: i + 1, // Associating student with the corresponding user
          study_plan_id: studyPlans[i % studyPlans.length].study_plan_id, // Select study plan cyclically
          enrollment_year: faker.date.past(5).getFullYear(), // Get only the year
          student_level_id: levels[i % levels.length].id, // Assign level cyclically
          student_system: system,
          repeat_years_count:faker.number.int({ min: 0, max: 3}),
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
