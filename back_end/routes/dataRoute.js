
const express = require('express');
const { getAllData } = require('../controllers/dataControll');
const router = express.Router();
const cors = require('cors');
const corsOptions = {
    origin: '*', // Replace with your Flutter Web app's URL (use IP or domain)
    methods: ['GET', 'POST', 'PUT', 'DELETE'], // Allow only necessary methods
    allowedHeaders: ['Accept', 'Content-Type', 'Authorization'], // Headers Flutter Web might send
    credentials: true, // Allow cookies or Authorization headers
  };
  
router.get('/all-data', cors(corsOptions), getAllData); 

module.exports = router;
