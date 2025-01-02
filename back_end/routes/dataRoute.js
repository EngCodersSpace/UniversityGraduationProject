
const express = require('express');
const CRUD = require('../controllers/dataControll');
const CRUD2 = require('../controllers/subjectController');

const router = express.Router();
const cors = require('cors');
const corsOptions = {
    origin: '*', // Replace with your Flutter Web app's URL (use IP or domain)
    methods: ['GET', 'POST', 'PUT', 'DELETE'], // Allow only necessary methods
    allowedHeaders: ['Accept', 'Content-Type', 'Authorization'], // Headers Flutter Web might send
    credentials: true, // Allow cookies or Authorization headers
};
  
router.get('/all-data', cors(corsOptions), CRUD.getAllData); 
router.get('/get-subjects', CRUD.getSubjects); 
router.get('/get-all-subjects', CRUD2.getAllSubject);
router.get('/get-all-sections', CRUD.getAllSections); 
router.get('/get-all-levels', CRUD.getAllLevels); 
router.get('/get-all-users', CRUD.getAllUsers); 
router.get('/get-all-doctors', CRUD.getAllDoctors); 
router.get('/get-all-students', CRUD.getAllStudents); 

module.exports = router;
