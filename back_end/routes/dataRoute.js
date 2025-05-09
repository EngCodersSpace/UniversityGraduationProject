// routes/dataRoute.js
const express = require('express');
const router = express.Router();
const exportController = require('../controllers/exportController');
const importController = require('../controllers/importController'); 
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });


const CRUD = require('../controllers/dataControll');
const CRUD2 = require('../controllers/subjectController');
  
router.get('/all-data', CRUD.getAllData); 
router.get('/get-subjects', CRUD.getSubjects); 
router.get('/get-all-subjects', CRUD2.getAllSubject);
router.get('/get-all-sections', CRUD.getAllSections); 
router.get('/get-all-levels', CRUD.getAllLevels); 
router.get('/get-all-users', CRUD.getAllUsers); 
router.get('/get-all-doctors', CRUD.getAllDoctors); 
router.get('/get-all-students', CRUD.getAllStudents); 

// Route: Export selected tables (with or without relations), as Excel
router.get('/export-to-excel', exportController.exportData);

//  Route: Import Excel file to DB
router.post('/import-to-db', upload.single('file'), importController.importData);

module.exports = router;