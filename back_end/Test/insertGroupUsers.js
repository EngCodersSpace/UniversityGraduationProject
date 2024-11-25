// insertUser.js
const { sequelize, user } = require('../models'); // Adjust the path if necessary

async function insertUsers() {
  try {
    // Authenticate the database connection
    await sequelize.authenticate();
    console.log('Connection has been established successfully.');

    // Array of new users to insert with unique phone numbers
    const users = [
      {
        user_id: 5,
        user_name: 'John Doe',
        date_of_birth: '1990-01-01',
        email: 'johnmn.doe@example.com',
        phone_number: '123456744890', // Unique phone number
        permission: 'student',
        password: 'securePassword123',
      },
      {
        user_id: 6,
        user_name: 'Jane Smith',
        date_of_birth: '1992-05-15',
        email: 'janase.smith@example.com',
        phone_number: '234564478901', // Unique phone number
        permission: 'teacher',
        password: 'securePassword456',
      },
      {
        user_id: 7,
        user_name: 'Alice Johnson',
        date_of_birth:'1985-11-30',
        email: 'alissace.johnson@example.com',
        phone_number: '345674489012', // Unique phone number
        permission: 'admin',
        password: 'securePassword789',
      },
    ];

    // Insert multiple users
    const createdUsers = await user.bulkCreate(users);
    console.log('Users created successfully:', createdUsers.map(user => user.toJSON()));
  } catch (error) {
    console.error('Error inserting users:', error);
    if (error.errors) {
      error.errors.forEach(err => {
        console.error('Validation error:', err.message);
      });
    }
  } finally {
    // Close the connection
    await sequelize.close();
  }
}

// Call the function to insert the users
insertUsers();