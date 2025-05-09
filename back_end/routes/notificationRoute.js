const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/notificationController');
const {checkPermission} = require('../middleware/roleMiddleware');

const { verifyToken } = require('../middleware/authMiddleware');
router.use(verifyToken);

// router.post('/create-notification',checkPermission('notification', 'write'),  CRUD.createNotification);

module.exports = router;