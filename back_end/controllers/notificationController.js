// notificationController.js
const { notification, user,role } = require('../models');
const admin = require('../config/firebase');
const { Op } = require('sequelize');
const  CRUD  = require('../utils/debounceKey');
const {isNotificationRelevant}=require('../utils/notificationUtils')
const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

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


const fetchRoleUserTypeMap = async () => {
  const roles = await role.findAll({
    attributes: ['id', 'user_type'],
    raw: true,
  });

  const roleMap = {};
  for (const { id, user_type } of roles) {
    roleMap[id] = user_type;
  }

  return roleMap;
};

//  Function to extract topic parts dynamically from a condition string
function extractTopicParts(conditionStr, roleUserTypeMap = {}) {
  if (typeof conditionStr !== 'string') {
    return {
      userType: [],
      sections: [],
      levels: [],
      roles: [],
    };
  }

  const normalized = conditionStr.replace(/`/g, "'");

  if (normalized.includes("'all' in topics")) {
    return {
      userType: ['all'],
      sections: [],
      levels: [],
      roles: [],
    };
  }

  const parts = {
    userType: [],
    sections: [],
    levels: [],
    roles: [],
  };

  // Split on logical ANDs
  const andGroups = normalized.split(/\s*&&\s*/);

  for (let group of andGroups) {
    const match = group.match(/\(([^()]+)\)/);
    const groupStr = match ? match[1] : group;

    // Split on logical ORs
    const items = groupStr.split(/\s*\|\|\s*/);

    for (let item of items) {
      const cleaned = item.replace(/'|in topics|\(|\)/g, '').trim();

      if (/^student|doctor$/.test(cleaned)) {
        if (!parts.userType.includes(cleaned)) parts.userType.push(cleaned);
      } else if (/^section_\d+$/.test(cleaned)) {
        if (!parts.sections.includes(cleaned)) parts.sections.push(cleaned);
      } else if (/^level_\d+$/.test(cleaned)) {
        if (!parts.levels.includes(cleaned)) parts.levels.push(cleaned);
      } else if (/^role_\d+$/.test(cleaned)) {
        // Extract numeric ID from 'role_1' => 1
        const roleId = cleaned.split('_')[1];
        const expectedUserType = roleUserTypeMap[roleId]; 
        if (
          !expectedUserType || // role ID not in map (maybe warn here?)
          parts.userType.includes(expectedUserType) || // userType matches expected
          parts.userType.includes('all') // universal
        ) {
          if (!parts.roles.includes(cleaned)) parts.roles.push(cleaned);
        }
      }
      
    }
  }

  return parts;
}

function generateConditions(filter) {
  const {
    userType = [],
    sections = [],
    levels = [],
    roles = [],
  } = filter;

  const conditions = [];

  if (userType.includes('all')) {
    conditions.push("'all' in topics");
    return conditions;
  }

  for (const user of userType) {
    for (const section of sections.length ? sections : [null]) {
      for (const role of roles.length ? roles : [null]) {
        if (user === 'student') {
          for (const level of levels.length ? levels : [null]) {
            const cond = [
              `'${user}' in topics`,
              section && `'${section}' in topics`,
              level && `'${level}' in topics`,
              role && `'${role}' in topics`,
            ].filter(Boolean).join(' && ');
            conditions.push(cond);
          }
        } else {
          const cond = [
            `'${user}' in topics`,
            section && `'${section}' in topics`,
            role && `'${role}' in topics`,
          ].filter(Boolean).join(' && ');
          conditions.push(cond);
        }
      }
    }
  }

  return conditions;
}



// INFORMATION Notification (stored in DB and sent)
const sendInfoNotification = async ({
  title,
  message,
  topic_name,
  sender_id,
  metadata = {},
  delay = 6000,
}) => {
  const roleUserTypeMap = await fetchRoleUserTypeMap();
  const parsed = extractTopicParts(topic_name, roleUserTypeMap);
  const conditions = generateConditions(parsed);

  console.log('\n \n   roleUserTypeMap',roleUserTypeMap,'\n  \n ');
  console.log('\n \n   Topics after Filter',parsed,'\n \n  ');
  console.log('\n \n   Generate Conditions',conditions,'\n \n \n ');

  const send = async () => {
    try {
      await notification.create({
        sender_id,
        topic_name,
        title,
        message,
        type: 'topic',
      });

      for (const condition of conditions) {
        const payload = {
          notification: { title, body: message },
          data: {
            type: 'information',
            ...metadata,
          },
          condition,
        };

        await admin.messaging().send(payload);
        console.log('✅ Sent to:', condition);
        await sleep(1000);
      }
    } catch (error) {
      console.error('❌ Notification failed:', error.message);
    }
  };

  CRUD.delayedSend(delay, send);
};

// SYSTEM Notification (not stored in DB)
const sendSystemNotification = async ({
  topic_name,
  metadata = {},
  delay = 3000,
}) => {

  const roleUserTypeMap = await fetchRoleUserTypeMap();
  const parsed = extractTopicParts(topic_name, roleUserTypeMap);
  const conditions = generateConditions(parsed);

  console.log('\n \n   roleUserTypeMap',roleUserTypeMap,'\n  \n ');
  console.log('\n \n   Topics after Filter',parsed,'\n \n  ');
  console.log('\n \n   Generate Conditions',conditions,'\n \n \n ');

  const send = async () => {
    try {
  
      for (const condition of conditions) {
        const payload = {
          data: {
            type: 'system',
            ...metadata,
          },
          condition,
        };

        await admin.messaging().send(payload);
        console.log('✅ Sent to:', condition);
      }
    } catch (error) {
      console.error('❌ Notification failed:', error.message);
    }
  };


  CRUD.delayedSend(delay, send)

};



// HANDLERS :
const sendInfoHandler = async (req, res) => {
  try {
    await sendInfoNotification(req.body);
    return res.json({ message: "send done successfullt" });
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

// to see what i received (single and topic)  user send topic_name in query          // depends (relation || in topics)
const getForRecieved = async (req, res) => {
  try{
  const notifications=await notification.findAll(
    {include: [
        {
          model: user, as: 'senderUser',
          attributes: ['user_id', 'user_name'],
        }
      ],}
  );

  const filteredNotifications = notifications.filter(notification =>
    isNotificationRelevant(req.body.topic_name, notification.topic_name)
  );

  const notifications1= await notification.findAll({
    where: {receiver_id: req.body.receiver_id },
    include: [
      {
          model: user,
          as: 'senderUser',    
          attributes: ['user_id', 'user_name'],
        },
        {
          model: user, as: 'receiverUser',
          attributes: ['user_id', 'user_name'],
        },
      ],
  });

  return res.status(200).json({message:"Get Notifications ", Data:[filteredNotifications , notifications1]});
  }catch(error){
    console.error(error);
    return res.status(500).json({ error: 'Failed to fetch Notifications .' ,error:error.message});
  }
};


// to see what i recieved (single)
const getForRecievedSingle = async (req, res) => {
  try{
  const notifications= await notification.findAll({
    where: {receiver_id: req.body.receiver_id },
    include: [
        {
          model: user, as: 'receiverUser',
          attributes: ['user_id', 'user_name'],
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
