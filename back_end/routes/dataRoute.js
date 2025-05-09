// routes/dataRoute.js

const express = require('express');
const router = express.Router();
const exportController = require('../controllers/exportController');
const importController = require('../controllers/importController'); 
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });

// Route: Export selected tables (with or without relations), as Excel
router.get('/export-to-excel', exportController.exportData);

//  Route: Import Excel file to DB
router.post('/import-to-db', upload.single('file'), importController.importData);

module.exports = router;
