//  routes/bookRoute.js

const express = require('express');
const router = express.Router();
const bookController = require('../controllers/bookController');
const { uploadFields } = require('../utils/multerConfig');

router.post('/upload', uploadFields, bookController.uploadFile);


router.get('/download/:id', bookController.downloadFile);

module.exports = router;