const { user, student } = require('../models');

async function addUserAndStudent() {
  try {
    // Create a  new user
    const newUser = await user.create({
      user_id: 1,
      user_name: 'John Doe',
      date_of_pirth: new Date('1990-01-01'),
      email: 'john.doe@example.com',
      phone_number: '1234567890',
      permission: 'student',
      password: 'securePassword123',
      description: 'A brief description about John Doe',
    });

    // Create a new student associated withe user
    const newStudent = await student.create({
      student_id: newUser.user_id, //Because the student_id = user_id and foreign key rfers to the user
      student_name: 'John Doe',
      student_section: 'Computer',
      enrollment_year: '2024',
      student_level: 'Freshman',
      status: 'Active',
      address: '123 Main St',
      gender: 'Male',
    });

    console.log('User and Student added successfully:', newUser.toJSON(), newStudent.toJSON());
  } catch (error) {
    console.error('Error adding user and student:', error);
  }
}

addUserAndStudent();