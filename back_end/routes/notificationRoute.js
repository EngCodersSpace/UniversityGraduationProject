const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/notificationController');
const {checkPermission} = require('../middleware/roleMiddleware');

const { verifyToken } = require('../middleware/authMiddleware');
router.use(verifyToken);


// Send an information notification (stored + visible to user)
router.post('/send-info',checkPermission('notifications','write'),CRUD.sendInfoHandler);

// Send a system notification (sync only, no DB storage, debounced)
router.post('/send-system', CRUD.sendSystemHandler);

// Fetch visible notifications (by userId and topics)
router.post('/fetch-by-topic', CRUD.fetchHandler);


module.exports = router;