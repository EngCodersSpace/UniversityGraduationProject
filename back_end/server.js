//  server.js
const express = require('express');
// const  { user }  = require('./models'); 
// const jwt = require('jsonwebtoken');
// const bcrypt = require('bcrypt');
// const SECRET_KEY = process.env.SECRET_KEY || "mySuperSecretKey1234567890123456" ;
const dotenv = require("dotenv");
dotenv.config({ path: './.env' });
const app = express();
app.use(express.json());


const authRoutes = require('./routes/authRoute')
const userRoutes = require('./routes/userRoute')
const studyPlanElement=require('./routes/studyPlaneElementRoute')

app.use(authRoutes);
app.use(userRoutes);
app.use(studyPlanElement);

// const doctorRoutes = require('./routes/doctorRoute');
// app.use(doctorRoutes);



const PORT = process.env.PORT ;
// Start server
app.listen(PORT, () => {
    console.log(`Server is running o port ${PORT}`);
});


















// const authRoutes = require('./routes/authRoute')
// app.use(authRoutes);

// const easyRoute = require('./routes/esayRoute')
// app.use('/api', easyRoute);
// const userRoutes = require('./routes/userRoute');


