const { sequelize, user } = require('../models');

    async function insertUser() {
        try {
          // Ensure the database connection is established
          await sequelize.authenticate();
          console.log('Connection has been established successfully.');
      
          const user1 = await user.create({
            user_id: 123,
            user_name: 'hameed',
            date_of_pirth: '2001-1-18',
            email: 'hameed@gmail.com',
            phone_number: '771899226',
            password: '77hs3ddsdc',
        });
      
          console.log('User created successfully:', user1.toJSON());
        } catch (error) {
          console.error('Error inserting post:', error);
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
      
      // Call the function to insert the post
      insertUser();
