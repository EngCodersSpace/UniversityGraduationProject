const { notification, user } = require('../models');
const admin = require('../config/firebase'); 
const {getNotificationRecipients} = require('../middleware/notificationMiddleware');


// GET all notifications
exports.getAllNotifications = async (req, res) => {
  try {
    const notifications = await notification.findAll();
    res.status(200).json({  message: 'retrieving notifications Successfully', data: notifications });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving notifications', error: error.message });
  }
};

// GET a single notification by ID (mesaage_id)
exports.getNotificationById = async (req, res) => {
  try {
    const { id } = req.params;
    const notif = await notification.findOne({
      where: { message_id: id },
    });

    if (!notif) {
      return res.status(404).json({ message: 'Notification not found' });
    }

    res.status(200).json({ message: 'Get Notification Successfully',data: notif });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving notification', error: error.message });
  }
};

// GET by (user_id)
exports.getNotificationsBySender = async (req, res) => {
  try {
    const { user_id } = req.params;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const offset = (page - 1) * limit;

    const { count, rows } = await notification.findAndCountAll({
      where: { sender_id: user_id },
      order: [['createdAt', 'DESC']],
      limit,
      offset,
      include: [{
        model: user,
        as: 'user',
        attributes: ['user_id']
      }]
    });

    res.status(200).json({
      total: count,
      page,
      totalPages: Math.ceil(count / limit),
      notifications: rows
    });

  } catch (error) {
    console.error('[Get Notifications Error]', error);
    res.status(500).json({
      message: 'Failed to fetch notifications',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};

// GET by (Topic)
exports.getNotificationsByTopic = async (req, res) => {
  try {
    const { topic } = req.params;
    const { type } = req.query;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const offset = (page - 1) * limit;

    const whereClause = {
      targetType: 'topic',
      targetValue: topic
    };

    if (type) {
      whereClause.type = type;
    }

    const { count, rows } = await notification.findAndCountAll({
      where: whereClause,
      order: [['createdAt', 'DESC']],
      limit,
      offset,
      include: [{
        model: user,
        as: 'user',
        attributes: ['user_id']
      }]
    });

    res.status(200).json({
      total: count,
      page,
      totalPages: Math.ceil(count / limit),
      notifications: rows
    });

  } catch (error) {
    console.error('[Get Notifications Error]', error);
    res.status(500).json({
      message: 'Failed to fetch notifications', error:error.message
    });
  }
};

// Update a notification  
exports.updateNotification = async (req, res) => {
  try {
    const { id } = req.params;
    const { sender_id, title, message, type } = req.body;

    const notif = await notification.findByPk(id);
    if (!notif) {
      return res.status(404).json({ message: 'Notification not found' });
    }

    await notif.update({ sender_id, title, message, type });
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



// //examples:
// // 1. Get all doctors
// const doctors = await getNotificationRecipients({
//   targetType: 'user_type',
//   roleId: 'doctors'
// });
// // 2. Get all deans (roleId = 1)
// const deans = await getNotificationRecipients({
//   targetType: 'role',
//   roleId: 1
// });
// // 3. Get Civil Engineering level 3 students
// const civil3 = await getNotificationRecipients({
//   targetType: 'section_level',
//   sectionId: 'civil',
//   levelId: 3
// });
// // 4. Broadcast to everyone
// const allUsers = await getNotificationRecipients({
//   targetType: 'broadcast'
// });



// Info Notification Controller (Topic-Based)
exports.createInfoNotification = async (req, res) => {
  const options = {
    defaultTitle: req.body.defaultTitle || 'Notification',
    notificationType: req.body.notificationType || 'info',
    androidChannel: req.body.androidChannel || 'info_channel'
  };

  try {
    const dbRecord = await notification.create({
      sender_id: req.user?.user_id || null,
      title: req.body.title || options.defaultTitle,
      message: req.body.message,
      type: options.notificationType,
    });

    const recipients = await getNotificationRecipients({
      targetType: req.body.targetType || 'topic',
      topic: req.body.topic,
      roleId: req.body.roleId,
      sectionId: req.body.sectionId,
      levelId: req.body.levelId
    });

    const fcmTokens = recipients.map(u => u.fcm_token).filter(Boolean);
    let deliveryResult = null;

    if (fcmTokens.length) {
      deliveryResult = await admin.messaging().sendMulticast({
        notification: {
          title: dbRecord.title,
          body: dbRecord.message,
        },
        data: {
          notification_id: dbRecord.id.toString(),
          type: dbRecord.type,
          ...(req.body.additionalData || {})
        },
        tokens: fcmTokens,
        android: {
          channelId: options.androidChannel
        }
      });
    }

    res.status(201).json({
      notification: dbRecord,
      stats: {
        targeted: recipients.length,
        delivered: fcmTokens.length,
        failed: deliveryResult?.failureCount || 0
      }
    });

  } catch (error) {
    console.error('[InfoNotification]', error);
    res.status(500).json({
      success: false,
      error: 'Notification processing failed',
      details: process.env.NODE_ENV === 'development' ? error.message : null
    });
  }
};


// admin panel
exports.getNotificationsByCriteriaPanel = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = [
    "message_id",
    "sender_id",
    "title",
    "message",
    "type",
  ];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      message_id,
      sender_id,
      title,
      message,
      type,
      page = 1,
      limit = 10,
      orderBy = "message_id",
      sort = "ASC",
      search,
    } = req.query;


    const pageNumber = parseInt(page, 10);
    let limitNumber = parseInt(limit, 10);

    const LOWER_LIMIT = 10;
    const UPPER_LIMIT = 250;
    if (isNaN(limitNumber)) limitNumber = LOWER_LIMIT;
    if (limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
    if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;

    const offset = (pageNumber - 1) * limitNumber;

    const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy)
      ? orderBy
      : "message_id";
    const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase())
      ? sort.toUpperCase()
      : "ASC";


    const { count, rows: notifications } = await notification.findAndCountAll({
      where: {
        ...(message_id && {
          message_id: message_id 
        }),
        ...(sender_id && {
          sender_id: sender_id 
        }),
        ...(type && {
          type: type 
        }),
    
        ...(search && {
          [Op.or]: [
            { message_id: { [Op.like]: `%${search}%` } },
            { sender_id: { [Op.like]: `%${search}%` } },
            { title: { [Op.like]: `%${search}%` } },
            { message: { [Op.like]: `%${search}%` } },
            { type: { [Op.like]: `%${search}%` } },        
          ]
        })
      },
      distinct: true, 
      limit: limitNumber,
      offset: offset,
      order: [[validOrderBy, validSort]],
    });

    if (!notifications.length) {
      return res
        .status(404)
        .json({ message: "No notifications found for the specified criteria" });
    }

    res.status(200).json({
      message: "notifications retrieved successfully",
      data: notifications,
      pagination: {
        totalStudents: count,
        totalPages: Math.ceil(count / limitNumber),
        currentPage: pageNumber,
        perPage: limitNumber,
      },
    });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Error retrieving notifications", error: error.message });
  }
};