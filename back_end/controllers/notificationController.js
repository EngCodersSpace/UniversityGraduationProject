// notificationController.js
const { notification, user } = require('../models');
const admin = require('../config/firebase');
const { Op } = require('sequelize');
const { debounceSend } = require('../utils/debounceKey');

// Send a single direct user notification
const sendSingleNotification = async (req, res) => {
  try {
    const { title, message, receiver_id, token} = req.body;
    const payload = {
      notification: { title, body: message },
      data: {
        type: 'single',
      },
      token,
    };
    await admin.messaging().send(payload);
    await notification.create({
      sender_id:req.user.user_id,
      receiver_id,
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

// as Middleware  :

// SYSTEM Notification (not stored in DB)
const sendSystemNotification = async ({
  topic_name,
  metadata = {},
  debounceKey = null,
  delay = 3000,
}) => {
  const send = async () => {
    const payload = {
      data: {
        type: 'system',
        ...metadata,
      },
    };
    payload.topic = topic_name;
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
  topic_name ,
  metadata = {},
  debounceKey = null,
  delay = 3000,
}) => {
  const send = async () => {
    const payload = {
      notification: { title, body: message },
      data: {
        type: 'information',
        ...metadata,
      },
    };
    payload.topic = topic_name;

    try {
      await notification.create({
        sender_id:req.user.user_id,
        topic_name,
        title,
        message,
        type: 'topic',
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

// HANDLERS :

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


// to see what i sent   and for who 
const getForSender = async (req, res) => {
  try{
  const notifications=await notification.findAll({
    where: {sender_id: req.query.sender_id },
    include: [
        {
          model: user,
          as: 'senderUser',
          attributes: ['user_id', 'user_name'],
        },
      ],
  });
  return res.status(200).json({message:"Get Notifications that you sent it", Data:notifications});
  }catch(error){
  console.error(error);
  return res.status(500).json({ error: 'Failed to fetch Notifications .' ,error:error.message});
  }
};

// to see what i received (single and topic)  user send topic_name in query
const getForRecieved = async (req, res) => {
  try{
  const notifications=await notification.findAll({
    where: {
      [Op.or]: [
        { receiver_id: req.query.receiver_id },
        { topic_name:  req.query.topic_name },
      ],
    },
    include: [
        {
          model: user,
          as: 'receiverUser',
          attributes: ['user_id', 'user_name'],
        },
        {
          model: user,
          as: 'senderUser',
          attributes: ['user_id', 'user_name'],
        },
      ],
  });
  return res.status(200).json({message:"Get Notifications ", Data:notifications});
  }catch(error){
    console.error(error);
    return res.status(500).json({ error: 'Failed to fetch Notifications .' ,error:error.message});
  }
};

// to see what i recieved (single)
const getForRecievedSingle = async (req, res) => {
  try{
  const notifications= await notification.findAll({
    // where: {receiver_id: req.user.user_id },
    include: [
        {
          model: user, as: 'receiverUser',
          attributes: ['user_id', 'user_name'],
          where: {receiver_id: req.user.user_id },
        }
      ],
  });
  return res.status(200).json({message:"Get Notifications that you received it", Data:notifications});
  }catch(error){
    console.error(error);
    return res.status(500).json({ error: 'Failed to fetch Notifications .' ,error:error.message});
  }
};

// to see what i recieved (topic)    user send topic_name in query
const getForRecievedByTopic = async (req, res) => {
  try{
  const notifications=await notification.findAll({
    where: {topic_name: req.query.topic_name},
    // order: [['createdAt', 'DESC']],

  });
  return res.status(200).json({message:`Get Notifications that you received it at ${req.query.topic_name}`, Data:notifications});
  }catch(error){
    console.error(error);
    return res.status(500).json({ error: 'Failed to fetch Notifications .' ,error:error.message});
  }
};

const getAllNotifications = async (req, res) => {
  try{
  const notifications=await notification.findAll();
  return res.status(200).json({message:"Get Notifications ", Data:notifications});
  }catch(error){
  console.error(error);
  return res.status(500).json({ error: 'Failed to fetch Notifications .' ,error:error.message});
  }
};


// admin panel
const getNotificationsPanel = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = [
    "message_id",
    "sender_id",
    "receiver_id",
    "topic_name",
    "title",
    "message",
    "type",
  ];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      sender_id,
      receiver_id,
      topic_name,
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
        ...(sender_id && {
          sender_id: sender_id 
        }),
        ...(receiver_id && {
          receiver_id: receiver_id 
        }),
        ...(type && {
          type: type 
        }), 
        ...(topic_name && {
          topic_name: topic_name 
        }), 
        
        ...(search && {
          [Op.or]: [
            { title: { [Op.like]: `%${search}%` } },
            { message: { [Op.like]: `%${search}%` } },
          ]
        })
      },
      include: [
        {
          model: user,
          as: 'receiverUser',
          attributes: ['user_id', 'user_name'],

        },
        {
          model: user,
          as: 'senderUser',
          attributes: ['user_id', 'user_name'],

        },
      ],

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
        totalNotifications: count,
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

module.exports = {
  sendSingleNotification,
  sendSystemNotification,
  sendInfoNotification,
  getAllNotifications,
  sendInfoHandler,
  sendSystemHandler,
  getNotificationsPanel,
  getForSender,
  getForRecieved,
  getForRecievedSingle,
  getForRecievedByTopic,
};