
const { Op } = require('sequelize');
const { notification, user } = require('../models');
const admin = require('../config/firebase');

// Middleware function
async function getNotificationRecipients({ targetType, roleId, userId, sectionId, levelId }) {
  switch (targetType) {
    case 'user_type':
      return await user.findAll({ 
        where: { 
          roleId: {
            [Op.in]: roleId === 'doctors' ? [1, 2, 3] : [4, 5] 
          }
        },
        attributes: ['user_id', 'fcm_token'] 
      });

    // Case 2: Specific roles (dean, controller etc.)
    case 'role':
      return await user.findAll({ 
        where: { roleId },
        attributes: ['user_id', 'fcm_token'] 
      });

    // Case 3: By section and level (e.g. Civil_3)
    case 'section_level':
      return await user.findAll({
        where: { user_section_id: sectionId },
        include: [{
          model: student,
          where: { student_level_id: levelId },
          required: true
        }],
        attributes: ['user_id', 'fcm_token']
      });

    // Case 4: Broadcast to all users
    case 'broadcast':
      return await user.findAll({
        attributes: ['user_id', 'fcm_token']
      });

    // Case 5: Specific user
    case 'specific':
      const userData = await user.findOne({ 
        where: { user_id: userId },
        attributes: ['user_id', 'fcm_token'] 
      });
      return userData ? [userData] : [];

    default:
      return [];
  }
}

// System Refresh Middleware (Silent Push)
const systemRefresh = (options = {}) => {
  return async (req, res, next) => {
    try {
      // 1. Skip if no refresh needed
      if (options.condition && !options.condition(req)) return next();

      // 2. Prepare refresh payload
      const payload = {
        data: {
          type: 'system_refresh',
          entity: options.entity || req.body?.entity_type,
          action: options.action || 'update',
          timestamp: Date.now().toString()
        },
        android: {
          priority: 'high',
          ttl: 3600 
        },
        apns: {
          headers: {
            'apns-priority': '5', // Silent push
            'apns-push-type': 'background'
          },
          payload: {
            aps: {
              'content-available': 1 // iOS background fetch
            }
          }
        }
      };

      // 3. Determine recipients
      if (options.targetType === 'broadcast') {
        // Send to all devices (system-wide refresh)
        await admin.messaging().sendToTopic('system_refreshes', payload);
      } else {
        // Targeted refresh (section/level/role)
        const recipients = await getNotificationRecipients({
          targetType: options.targetType,
          sectionId: req.body?.section_id,
          levelId: req.body?.level_id,
          roleId: req.body?.role_id
        });
        
        const tokens = recipients.map(u => u.fcm_token).filter(Boolean);
        if (tokens.length) {
          await admin.messaging().sendMulticast({ ...payload, tokens });
        }
      }

      next();
    } catch (error) {
      console.error(`[SystemRefresh] ${options.entity}`, error);
      next(); // Fail silently
    }
  };
};


// Info Notification Middleware (Topic-Based)
const createInfoNotifi = (options = {}) => {
  return async (req, res, next) => {
    try {
      // 1. Create database record
      const dbRecord = await notification.create({
        sender_id: req.user?.user_id || null,
        title: req.body.title || options.defaultTitle,
        message: req.body.message,
        type: options.notificationType || 'info',
        metadata: options.metadata?.(req) || null
      });

      // 2. Determine recipients (default to topic targeting)
      const recipients = await getNotificationRecipients({
        targetType: 'topic',
        topic: req.body.topic || options.defaultTopic
      });

      // 3. Send FCM notifications
      const fcmTokens = recipients.map(u => u.fcm_token).filter(Boolean);
      if (fcmTokens.length) {
        await admin.messaging().sendMulticast({
          notification: {
            title: dbRecord.title,
            body: dbRecord.message,
            imageUrl: options.imageUrl
          },
          data: {
            notification_id: dbRecord.id.toString(),
            type: dbRecord.type,
            ...(options.additionalData?.(req) || {})
          },
          tokens: fcmTokens,
          android: {
            channelId: options.androidChannel || 'info_channel'
          }
        });
      }

      // 4. Attach results to request
      req.notificationResult = {
        dbRecord,
        recipients: recipients.length,
        successfulDeliveries: fcmTokens.length
      };

      next();
    } catch (error) {
      console.error('[InfoNotification]', error);
      req.notificationError = error;
      next(); // Continue to next middleware/route
    }
  };
};







// // Middleware للتحقق من صحة Topics
// exports.validateNotificationTopics = (req, res, next) => {
//   const validPatterns = [
//     /^userType_(doctor|student)$/,
//     /^role_\d+$/,
//     /^section_level_\w+_\d+$/,
//     /^all_users$/
//   ];
  
//   if (req.body.topic && !validPatterns.some(p => p.test(req.body.topic))) {
//     return res.status(400).json({
//       success: false,
//       error: 'Invalid topic format',
//       validExamples: [
//         'userType_doctor',
//         'role_1',
//         'section_level_civil_3',
//         'all_users'
//       ]
//     });
//   }
//   next();
// };

// // Middleware لتسجيل الإشعار في DB
// exports.logNotification = async (req, res, next) => {
//   try {
//     const { title, message, topic, data } = req.body;
    
//     req.notificationRecord = await notification.create({
//       sender_id: req.user?.user_id,
//       title,
//       message,
//       type: topic ? 'topic' : 'direct',
//       target: topic || req.body.userId?.toString(),
//       metadata: data
//     });
    
//     next();
//   } catch (error) {
//     console.error('[Notification Log Error]', error);
//     next(error);
//   }
// };

// // Middleware لإرسال الإشعارات عبر Topics
// exports.sendTopicNotification = async (req, res, next) => {
//   try {
//     if (!req.body.topic) return next();
    
//     const message = {
//       topic: req.body.topic,
//       notification: {
//         title: req.body.title,
//         body: req.body.message
//       },
//       data: {
//         notification_id: req.notificationRecord.id.toString(),
//         type: 'topic_alert',
//         ...req.body.data
//       },
//       android: {
//         priority: 'high'
//       }
//     };

//     req.fcmResponse = await admin.messaging().send(message);
//     next();
//   } catch (error) {
//     console.error('[FCM Topic Error]', error);
//     next(error);
//   }
// };

// // Middleware لإرسال إشعارات مباشرة
// exports.sendDirectNotification = async (req, res, next) => {
//   try {
//     if (!req.body.userId) return next();
    
//     const userData = await user.findOne({
//       where: { user_id: req.body.userId },
//       attributes: ['fcm_token']
//     });

//     if (!userData?.fcm_token) {
//       return next(new Error('User device not registered'));
//     }

//     const message = {
//       token: userData.fcm_token,
//       notification: {
//         title: req.body.title,
//         body: req.body.message
//       },
//       data: {
//         notification_id: req.notificationRecord.id.toString(),
//         type: 'direct_alert',
//         ...req.body.data
//       }
//     };

//     req.fcmResponse = await admin.messaging().send(message);
//     next();
//   } catch (error) {
//     console.error('[FCM Direct Error]', error);
//     next(error);
//   }
// };

// // Middleware لجلب الإشعارات
// exports.fetchUserNotifications = async (req, res, next) => {
//   try {
//     const { userId } = req.params;
//     const { topics } = req.query;

//     if (!topics) {
//       return res.status(400).json({
//         success: false,
//         error: 'Topics parameter is required'
//       });
//     }

//     req.notifications = await notification.findAll({
//       where: {
//         [Op.or]: [
//           { target: { [Op.in]: topics.split(',') } },
//           { target: userId, type: 'direct' }
//         ]
//       },
//       order: [['createdAt', 'DESC']],
//       limit: parseInt(req.query.limit) || 20,
//       offset: parseInt(req.query.offset) || 0
//     });
    
//     next();
//   } catch (error) {
//     console.error('[Fetch Notifications Error]', error);
//     next(error);
//   }
// };









module.exports = {getNotificationRecipients , systemRefresh ,createInfoNotifi};