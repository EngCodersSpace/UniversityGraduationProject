// dropUsers.js
const { sequelize, user } = require('../models'); // Adjust the path if necessary


//Drop All Users
async function dropAllUsers() {
  try {
    // Authenticate the database connection
    await sequelize.authenticate();
    console.log('Connection has been established successfully.');

    // Delete all User records
    const deletedCount = await user.destroy({
      where: {}, // Empty where clause to delete all records
    });

    console.log(`Deleted ${deletedCount} User(s) successfully.`);
  } catch (error) {
    console.error('Error deleting Users:', error);
  } finally {
    // Close the connection
    await sequelize.close();
  }
}

             // Call the function to drop all Users

//dropAllUsers();

dropAllUsers();

async function deleteUser(userId) {
  try {
    //If delet the user the row associated with it will be deleted.
    await user.destroy({ where: { user_id: userId } });

    console.log(`User with ID ${userId} deleted successfully.`);
  } catch (error) {
    console.error('Error deleting user:', error);
  }
}


deleteUser(1); //User ID you want to delets