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
  allowedHeaders: ['Accept', 'Content-Type', 'Authorization'], // Headers Flutter Web might send
  credentials: true, // Allow cookies or Authorization headers
};

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



app.use(mainRouter);
app.use(authRoutes);
app.use(userRoutes);
app.use(studyPlanElementRoute);
app.use(examRoute);
app.use(gradeRoute);
app.use(lectureRoute);
app.use(phoneNumber);

app.use(cors());


const PORT = process.env.PORT ;
app.listen(PORT, () => {
    console.log(`Server is running o port ${PORT}`);
});





