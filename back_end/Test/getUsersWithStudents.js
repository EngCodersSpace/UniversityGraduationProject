const { user, student } = require('../models'); 

async function getUsersWithStudents() {
    try {
      const users = await user.findAll({
        include: [{
          model: student,
          foreignKey: 'student_id',
        }],
      });
  
      console.log('Users with their students:', JSON.stringify(users, null, 2));
    } catch (error) {
      console.error('Error fetching users with students:', error);
    }
  }
  
  getUsersWithStudents();