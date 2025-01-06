//  routes/bookRoute.js

const express = require('express');
const router = express.Router();
const bookController = require('../controllers/bookController');
const { verifyToken } = require('../middleware/authMiddleware');

router.use(verifyToken);

router.post('/upload',verifyToken,  bookController.uploadFile);
router.get('/download', bookController.downloadFile);

module.exports = router;