const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/notificationController');
const {checkPermission} = require('../middleware/roleMiddleware');
const { verifyToken } = require('../middleware/authMiddleware');

router.use(verifyToken);

// To Send single Notification
router.post('/send-single-noti', CRUD.sendSingleNotification);
router.get('/get-all-noti-panel', CRUD.getNotificationsPanel);

router.post('/send-info-noti', CRUD.sendInfoHandler);

router.get('/Get-noti-byTopic',CRUD.getForRecievedByTopic);
router.get('/Get-noti-single',CRUD.getForRecievedSingle);
router.get('/Get-noti-sender',CRUD.getForSender);
router.get('/Get-noti-recieved',CRUD.getForRecieved);


// Send an information notification (stored + visible to user)
// router.post('/send-info',checkPermission('notifications','write'),CRUD.sendSystemHandler);
// Send a system notification (sync only, no DB storage, debounced)
// router.post('/send-system', CRUD.sendSystemHandler);
// Fetch visible notifications (by userId and topics)
// router.post('/fetch-by-topic', CRUD.fetchHandler);


module.exports = router;