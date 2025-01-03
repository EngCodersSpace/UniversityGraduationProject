
const express = require('express');
const router = express.Router();
const bookController = require('../controllers/bookController');
const multer = require('multer');

// Configure multer middleware for file upload
const upload = multer({ dest: 'uploads/' });

// Routes
router.post('/upload', upload.single('file'), bookController.uploadBook);
router.get('/download/:id', bookController.downloadBook);

module.exports = router;














