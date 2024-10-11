//  server.js
const express = require('express');
const dotenv = require("dotenv");
// const { user } = require('./models'); 
// const router = express.Router();

dotenv.config({ path: './.env' });
const app = express();
app.use(express.json());

// const easyRoute = require('./routes/esayRoute')
// app.use('/api', easyRoute);
// const userRoutes = require('./routes/userRoute');

const authRoutes = require('./routes/authRoute')

app.use(authRoutes);
// app.use('/api', userRoutes);

const PORT = process.env.PORT ;
// Start server
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});












