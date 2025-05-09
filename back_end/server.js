//  server.js
const express = require('express');
const dotenv = require("dotenv");
dotenv.config({ path: './.env' });
const cors = require('cors');
const app = express();
app.use(express.json());

const corsOptions = {
  origin: '*', // Replace with your Flutter Web app's URL (use IP or domain)
  methods: ['GET', 'POST', 'PUT', 'DELETE'], // Allow only necessary methods
  allowedHeaders: ['Accept', 'Content-Type', 'Authorization','accept-language'], // Headers Flutter Web might send
  credentials: true, // Allow cookies or Authorization headers
};

// Rest of  application code
app.use(cors(corsOptions));
app.options('*', cors(corsOptions)); 

const mainRouter = require('./routes/mainRoute')
const authRoutes = require('./routes/authRoute')
const userRoutes = require('./routes/userRoute')
const studyPlanElementRoute=require('./routes/studyPlaneElementRoute')
const examRoute=require('./routes/examRoute')
const gradeRoute=require('./routes/gradeRoute')
const lectureRoute=require('./routes/lectureRoute')
const phoneNumber=require('./routes/phoneNumberRoute')
const getData=require('./routes/dataRoute')
const subject=require('./routes/subjectRoute')
const studyPlaneRoute=require('./routes/studyPlaneRoute')
const studentFeeRoute=require('./routes/studentFeeRoute')
const bookRoutes = require('./routes/bookRoute');
const assignmentRoutes = require('./routes/assignmentRoute');
const rolePermissionRoutes = require('./routes/rolePermissionRoutes');
const notificationRoute= require('./routes/notificationRoute');
const refreshRoute=require('./routes/refreshRoute')


app.use(getData);
app.use(mainRouter);
app.use(authRoutes);
app.use(userRoutes);
app.use(studyPlanElementRoute);
app.use(examRoute);
app.use(gradeRoute);
app.use(lectureRoute);
app.use(phoneNumber);
app.use(subject);
app.use(studyPlaneRoute);
app.use(studentFeeRoute);
app.use(bookRoutes);
app.use(assignmentRoutes);
app.use(rolePermissionRoutes);
app.use(notificationRoute);
app.use(refreshRoute);

const PORT = process.env.PORT ;
app.listen(PORT, () => {
  console.log(`Server is running o port ${PORT}`);
});





