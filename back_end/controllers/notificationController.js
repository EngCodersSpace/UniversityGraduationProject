const { notification, user ,student} = require('../models');
const admin = require('../config/firebase'); 


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



// Middleware function
async function getNotificationRecipients({ targetType, roleid, user_id, section_id, level_id }) {
  switch (targetType) {
    case 'topic':
      return await user.findAll({ 
        where: { roleId: roleid },
        attributes: ['user_id', 'fcm_token'] 
      });
      
    case 'specific':
      const userData = await user.findOne({ 
        where: { user_id },
        attributes: ['user_id', 'fcm_token'] 
      });
      return userData ? [userData] : [];
      
    case 'condition':
      return await user.findAll({
        where: { user_section_id: section_id },
        include: [{
          model: student,
          where: { student_level_id:level_id }
        }],
        attributes: ['user_id', 'fcm_token']
      });
      
    default:
      return [];
  }
}



// system type
exports.sendSystemNotification = async (req, res) => {
  try {
    const recipients = await getNotificationRecipients(req.body);
    const fcmTokens = recipients.map(u => u.fcm_token).filter(Boolean);

    if (!fcmTokens.length) {
      return res.status(404).json({ message: 'No active devices found' });
    }

    const response = await admin.messaging().sendMulticast({
      data: {
        type: 'system_refresh',
        message: req.body.message || 'Data updated'
      },
      android: {
        collapseKey: 'data_refresh',
        priority: 'normal'
      },
      tokens: fcmTokens
    });

    res.status(200).json({
      devices: fcmTokens.length,
      failed: response.failureCount
    });
    
  } catch (error) {
    console.error('[System Push Error]', error);
    res.status(500).json({ 
      error: 'System notification failed',
      details: process.env.NODE_ENV === 'development' ? error.message : null
    });
  }
};

// info type
exports.createInfoNotification = async (req, res) => {
  try {
    const dbRecord = await notification.create({
      sender_id: req.user.user_id,
      title: req.body.title,
      message: req.body.message,
      type: 'info'
    });

    const recipients = await getNotificationRecipients(req.body);
    const fcmTokens = recipients.map(u => u.fcm_token).filter(Boolean);

    if (fcmTokens.length) {
      await admin.messaging().sendMulticast({
        notification: {
          title: req.body.title,
          body: req.body.message
        },
        data: {
          notification_id: dbRecord.message_id.toString(),
          type: 'user_alert'
        },
        tokens: fcmTokens
      });
    }

    res.status(201).json({
      success: true,
      notification: dbRecord,
      recipients: recipients.length
    });
    
  } catch (error) {
    console.error('[Info Push Error]', error);
    res.status(500).json({
      error: 'Notification failed',
      saved_to_db: !!dbRecord, 
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