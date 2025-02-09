const { notification, user ,student} = require('../models');
const admin = require('../config/firebase'); 

// Create a new notification and send it to users based on section_id, level_id, or roleId
exports.createNotification = async (req, res) => {

  try {
    const newNotification = await notification.create({
      sender_id :req.user.user_id,
      title:req.body.title,
      message:req.body.message,
      is_read:req.body.is_read,
      type:req.body.type,
    });

    const whereClause = {};
    if (req.body.section_id) whereClause.user_section_id = req.body.section_id;
    if (req.body.roleId) whereClause.roleId = req.body.roleId;

    const includeClause = [];
    if (req.body.level_id) {
      includeClause.push({
        model: student, 
        where: { level_id :req.body.level_id}, 
        include: [
          {
            model: level, 
            as: 'level',
          },
        ],
      });
    }

    const recipientUsers = await user.findAll({
      where: whereClause, 
      include: includeClause,
      attributes: ['user_id', 'fcm_token'], 
    });

    if (!recipientUsers || recipientUsers.length === 0) {
      return res.status(404).json({ message: 'No valid recipients found' });
    }

    const fcmTokens = recipientUsers
      .map((user) => user.fcm_token)
      .filter((token) => token); 

    if (fcmTokens.length === 0) {
      return res.status(404).json({ message: 'No valid FCM tokens found' });
    }

    const payload = {
      notification: {
        title: req.body.title,
        body: req.body.message,
      },
      data: {
        type: req.body.type, 
        sender_id:req.user.user_id.toString(),
      },
      tokens: fcmTokens, 
    };

    const response = await admin.messaging().sendMulticast(payload);
    console.log('Notifications sent successfully:', response);

    res.status(201).json({ message: 'Notification created and sent successfully', data: newNotification });
  } catch (error) {
    console.error('Error creating or sending notifications:', error.message);
    res.status(500).json({ message: 'Error creating or sending notifications', error: error.message });
  }
};


exports.insertFCMToken = async (req, res) => {
  const { user_id, fcm_token } = req.body;

  try {
    const foundUser = await user.findOne({ where: { user_id } });
    if (!foundUser) {
      return res.status(404).json({ message: 'User not found' });
    }

    foundUser.fcm_token = fcm_token;
    await foundUser.save();

    res.status(200).json({ message: 'FCM token updated successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error updating FCM token', error: error.message });
  }
};







// Get all notifications
exports.getAllNotifications = async (req, res) => {
  try {
    const notifications = await notification.findAll({
      include: {
        model: user,
        attributes: ['user_id', 'name', 'email'], // Add user fields you want to include
      },
    });
    res.status(200).json({ data: notifications });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving notifications', error: error.message });
  }
};

// Get a single notification by ID
exports.getNotificationById = async (req, res) => {
  try {
    const { id } = req.params;
    const notif = await notification.findOne({
      where: { message_id: id },
      include: {
        model: user,
        attributes: ['user_id', 'name', 'email'],
      },
    });

    if (!notif) {
      return res.status(404).json({ message: 'Notification not found' });
    }

    res.status(200).json({ data: notif });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving notification', error: error.message });
  }
};

// Update a notification  //?
exports.updateNotification = async (req, res) => {
  try {
    const { id } = req.params;
    const { sender_id, title, message, is_read, type } = req.body;

    const notif = await notification.findByPk(id);
    if (!notif) {
      return res.status(404).json({ message: 'Notification not found' });
    }

    await notif.update({ sender_id, title, message, is_read, type });
    res.status(200).json({ message: 'Notification updated successfully', data: notif });
  } catch (error) {
    res.status(500).json({ message: 'Error updating notification', error: error.message });
  }
};

// Delete a notification
exports.deleteNotification = async (req, res) => {
  try {
    const { id } = req.params;

    const notif = await notification.findByPk(id);
    if (!notif) {
      return res.status(404).json({ message: 'Notification not found' });
    }

    await notif.destroy();
    res.status(200).json({ message: 'Notification deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting notification', error: error.message });
  }
};