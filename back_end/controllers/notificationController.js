const { notification, user } = require('../models');

// Create a new notification
exports.createNotification = async (req, res) => {
  try {
    const { sender_id, title, message, is_read, type } = req.body;
    const newNotification = await notification.create({
      sender_id,
      title,
      message,
      is_read,
      type,
    });
    res.status(201).json({ message: 'Notification created successfully', data: newNotification });
  } catch (error) {
    res.status(500).json({ message: 'Error creating notification', error: error.message });
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

// Update a notification
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
