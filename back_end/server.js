//  server.js
const express = require('express');
const dotenv = require("dotenv");
dotenv.config({ path: './.env' });
const app = express();
app.use(express.json());

const authRoutes = require('./routes/authRoute')
const userRoutes = require('./routes/userRoute')
const studyPlanElementRoute=require('./routes/studyPlaneElementRoute')
const examRoute=require('./routes/examRoute')
const gradeRoute=require('./routes/gradeRoute')
const lectureRoute=require('./routes/lectureRoute')

app.use(authRoutes);
app.use(userRoutes);
app.use(studyPlanElementRoute);
app.use(examRoute);
app.use(gradeRoute);
app.use(lectureRoute);


const PORT = process.env.PORT ;
app.listen(PORT, () => {
    console.log(`Server is running o port ${PORT}`);
});





