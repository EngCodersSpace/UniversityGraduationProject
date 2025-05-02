const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/notificationController');
const { verifyToken } = require('../middleware/authMiddleware');
router.use(verifyToken);

// router.post('/create-notification', CRUD.createNotification);

module.exports = router;