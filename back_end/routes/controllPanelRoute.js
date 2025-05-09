//  routes/bookRoute.js
const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/controllPanel');
const { verifyToken } = require('../middleware/authMiddleware');
router.use(verifyToken);

// router.post('/upload-from-excel', CRUD.uploadExcelFile);

// router.get('/download-to-excel', CRUD.exportDatabase);

router.get('/downloads-to-excel',CRUD.downloadToExcel);

module.exports = router;