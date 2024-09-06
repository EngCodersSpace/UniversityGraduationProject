const express = require('express');
const sequelize = require('./src/config/database');
const authRoutes = require('./src/routes/authRoutes');
const studentRoutes = require('./src/routes/studentRoutes');

const app = express();
app.use(express.json());




// تسجيل المسارات المختلفة
app.use('/api/auth', authRoutes);     
app.use('/api/students', studentRoutes); 




//
sequelize.sync().then(() => {
  app.listen(3000, () => {
    console.log('Server is running on port 3000');
  });
}).catch(error => {
  console.error('Unable to connect to the database:', error);
});



//






