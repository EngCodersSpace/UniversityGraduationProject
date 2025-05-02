const { notification, user ,student} = require('../models');
const admin = require('../config/firebase'); 

// Create a new notification and send it to users based on section_id, level_id, or roleId    info type
exports.createNotification = async (req, res) => {

  try {
    const newNotification = await notification.create({
      sender_id :req.user.user_id,
      title:req.body.title,
      message:req.body.message,
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
      data: { // message to refresh   handel (use collapse )auto delay before sending data 
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
// add ( topic - specific - condition)   (byrole=topic in frontend)
// specific -> user_id
// topic    -> (is student or doctor)
// if s     -> ( sections - levels )
// 

// push data without add to db after each refresh  ()
// push notification when important things




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

// Get a single notification by ID user_is
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



exports.getNotificationsByCriteriaPanel = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = [
    "message_id",
    "sender_id",
    "title",
    "message",
    "is_read",
    "type",
  ];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      message_id,
      sender_id,
      title,
      message,
      is_read,
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
        ...(is_read && {
          is_read: is_read 
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
            { is_read: { [Op.like]: `%${search}%` } },
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