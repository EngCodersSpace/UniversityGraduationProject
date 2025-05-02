
const { notification, user ,student} = require('../models');
const admin = require('../config/firebase'); 

const notificationMiddleware = async (req, res, next) => {
    try {
      // Extract necessary data from request or pass explicitly
      const notificationData = {
        sender_id: req.user?.user_id || req.body.sender_id,
        title: req.body.title,
        message: req.body.message,
        is_read: req.body.is_read || false,
        type: req.body.type,
        section_id: req.body.section_id,
        level_id: req.body.level_id,
        roleId: req.body.roleId
      };
  
      // Validate required fields
      if (!notificationData.title || !notificationData.message || !notificationData.type) {
        console.log('Notification middleware skipped - missing required fields');
        return next();
      }
  
      // Create the notification record
      const newNotification = await notification.create({
        sender_id: notificationData.sender_id,
        title: notificationData.title,
        message: notificationData.message,
        is_read: notificationData.is_read,
        type: notificationData.type,
      });
  
      // Build query to find recipients
      const whereClause = {};
      if (notificationData.section_id) whereClause.user_section_id = notificationData.section_id;
      if (notificationData.roleId) whereClause.roleId = notificationData.roleId;
  
      const includeClause = [];
      if (notificationData.level_id) {
        includeClause.push({
          model: student,
          where: { level_id: notificationData.level_id },
          include: [
            {
              model: level,
              as: 'level',
            },
          ],
        });
      }
  
      // Find recipient users
      const recipientUsers = await user.findAll({
        where: whereClause,
        include: includeClause,
        attributes: ['user_id', 'fcm_token'],
      });
  
      if (!recipientUsers || recipientUsers.length === 0) {
        console.log('No valid recipients found for notification');
        return next();
      }
  
      // Prepare FCM tokens
      const fcmTokens = recipientUsers
        .map((user) => user.fcm_token)
        .filter((token) => token);
  
      if (fcmTokens.length === 0) {
        console.log('No valid FCM tokens found for notification');
        return next();
      }
  
      // Prepare and send notification
      const payload = {
        notification: {
          title: notificationData.title,
          body: notificationData.message,
        },
        data: {
          type: notificationData.type,
          sender_id: notificationData.sender_id.toString(),
        },
        tokens: fcmTokens,
      };
  
      const response = await admin.messaging().sendMulticast(payload);
      console.log('Notifications sent successfully:', response);
  
      // Attach notification data to request for use in route handler if needed
      req.notificationResult = {
        success: true,
        notification: newNotification,
        recipients: recipientUsers.length,
        fcmResponse: response
      };
  
      next();
    } catch (error) {
      console.error('Error in notification middleware:', error.message);
      // Don't fail the request if notification fails - just log and continue
      next();
    }
};







module.exports = {notificationMiddleware};