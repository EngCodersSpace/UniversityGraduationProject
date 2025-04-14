//  routes/bookRoute.js
const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/controllPanel');
const { verifyToken } = require('../middleware/authMiddleware');
router.use(verifyToken);

router.post('/upload-from-excel', CRUD.uploadExcelFile);



module.exports = router;