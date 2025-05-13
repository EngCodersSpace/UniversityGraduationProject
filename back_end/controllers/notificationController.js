// notificationController.js
const { notification, user } = require('../models');
const admin = require('../config/firebase');
const { Op } = require('sequelize');
const { debounceSend } = require('../utils/debounceKey');

// Send a single direct user notification
const sendSingleNotification = async (req, res) => {
  try {
    const { title, message, sender_id, receiver_id, token, metadata } = req.body;

    const payload = {
      notification: { title, body: message },
      data: {
        type: 'single',
        ...metadata,
      },
      token,
    };

    // Send to FCM
    await admin.messaging().send(payload);

    // Save to DB
    await notification.create({
      sender_id,
      receiver_id,
      topic_name: null,
      title,
      message,
      type: 'single',
    });

    res.json({ message: "Send notification Successfully",data:notification });
  } catch (error) {
    console.error('Single notification failed:', error);
    res.status(500).json({ error: 'Sending single notification failed' });
  }
};

// SYSTEM Notification (not stored in DB)
const sendSystemNotification = async ({
  target,
  topicType = 'topic',
  metadata = {},
  debounceKey = null,
  delay = 1000,
}) => {
  const send = async () => {
    const payload = {
      data: {
        type: 'system',
        ...metadata,
      },
    };

    if (topicType === 'topic') {
      payload.topic = target;
    } else {
      payload.token = target;
    }

    try {
      await admin.messaging().send(payload);
    } catch (error) {
      console.error('System notification failed:', error);
    }
  };

  if (debounceKey) {
    debounceSend(`system-${debounceKey}`, delay, send);
  } else {
    await send();
  }
};

// INFORMATION Notification (stored in DB and sent)
const sendInfoNotification = async ({
  title,
  message,
  sender_id,
  type = 'single', // 'single' or 'topic'
  receiver_id = null,
  topic_name = null,
  target,
  metadata = {},
  debounceKey = null,
  delay = 1000,
}) => {
  const send = async () => {
    const payload = {
      notification: { title, body: message },
      data: {
        type: 'information',
        ...metadata,
      },
    };

    if (type === 'topic') {
      payload.topic = target;
    } else {
      payload.token = target;
    }

    try {
      await notification.create({
        sender_id,
        receiver_id: type === 'single' ? receiver_id : null,
        topic_name: type === 'topic' ? topic_name : null,
        title,
        message,
        type,
      });

      await admin.messaging().send(payload);
    } catch (error) {
      console.error('Info notification failed:', error);
    }
  };

  if (debounceKey) {
    debounceSend(`info-${debounceKey}`, delay, send);
  } else {
    await send();
  }
};

// Fetch notifications for a user and subscribed topics
const fetchNotifications = async (userId, topicNames = []) => {
  return notification.findAll({
    where: {
      [Op.or]: [
        { receiver_id: userId },
        { topic_name: { [Op.in]: topicNames } },
      ],
    },
    order: [['createdAt', 'DESC']],
  });
};

// HANDLERS
const sendInfoHandler = async (req, res) => {
  try {
    await sendInfoNotification(req.body);
    res.json({ success: true });
  } catch (err) {
    console.error('Send info failed:', err);
    res.status(500).json({ error: 'Sending info notification failed' });
  }
};

const sendSystemHandler = async (req, res) => {
  try {
    await sendSystemNotification(req.body);
    res.json({ success: true });
  } catch (err) {
    console.error('Send system failed:', err);
    res.status(500).json({ error: 'Sending system notification failed' });
  }
};

const fetchHandler = async (req, res) => {
  try {
    const { userId, topics } = req.body;
    const notifications = await fetchNotifications(userId, topics);
    res.json(notifications);
  } catch (err) {
    console.error('Fetch notifications failed:', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

module.exports = {
  sendSingleNotification,
  sendSystemNotification,
  sendInfoNotification,
  fetchNotifications,
  sendInfoHandler,
  sendSystemHandler,
  fetchHandler,
};
