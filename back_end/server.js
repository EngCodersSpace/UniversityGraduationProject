//  server.js
const express = require('express');
const dotenv = require("dotenv");
dotenv.config({ path: './.env' });
const cors = require('cors');
const app = express();
app.use(express.json());



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





