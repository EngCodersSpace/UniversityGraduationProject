// fetchUsers.js
const { sequelize, user } = require('../models'); // Adjust the path if necessary

async function fetchAllUsers() {
  try {
    // Authenticate the database connection
    await sequelize.authenticate();
    console.log('Connection has been established successfully.');

    // Retrieve all users
    const users = await user.findAll();

    // Log the users to the console
    console.log('All Users:', JSON.stringify(users, null, 2));
  } catch (error) {
    console.error('Error fetching users:', error);
  } finally {
    // Close the connection
    await sequelize.close();
  }
}

// Call the function to fetch all users
fetchAllUsers();