
// const { sendInfoNotification } = require('../controllers/notificationController');
// const admin = require('../config/firebase');

// const debounceMap = new Map();

// const handleSystemAction = ({
//   bounceKey,
//   delay = 3000,
//   target,
//   metadata = {},
//   title,
//   message,
//   sender_id,
//   topicType = 'topic',
// }) => {
//   if (debounceMap.has(bounceKey)) {
//     clearTimeout(debounceMap.get(bounceKey));
//   }

//   const timeoutId = setTimeout(() => {
//     sendInfoNotification({
//       title,
//       message,
//       type: 'information',
//       target,
//       sender_id,
//       topicType,
//       metadata,
//     }).catch(console.error);

//     debounceMap.delete(bounceKey);
//   }, delay);

//   debounceMap.set(bounceKey, timeoutId);
// };

// const sendSyncNotification = ({
//   bounceKey,
//   delay = 3000,
//   target,
//   metadata = {},
//   topicType = 'topic',
// }) => {
//   if (debounceMap.has(bounceKey)) {
//     clearTimeout(debounceMap.get(bounceKey));
//   }

//   const timeoutId = setTimeout(() => {
//     const payload = {
//       data: {
//         type: 'sync_trigger',
//         ...metadata,
//       },
//     };

//     if (topicType === 'topic') {
//       payload.topic = target;
//     } else {
//       payload.token = target;
//     }

//     admin.messaging().send(payload).catch(console.error);
//     debounceMap.delete(bounceKey);
//   }, delay);

//   debounceMap.set(bounceKey, timeoutId);
// };

// module.exports = {
//   handleSystemAction,
//   sendSyncNotification,
// };
//   const type = topic ? 'topic' : 'single';
//   const target = topic || receiverId;

//   const notification = await notification.create({
//     title,
//     message,
//     type,
//     target,
//     senderId,
//     receiverId: topic ? null : receiverId,
//     data,
//   });

//   await fcm.send(target, title, message, { type: 'information', notificationId: notification.message_id, ...data }, !!topic);
//   return notification;
  
// };

// exports.sendDebouncedInfoNotification = async ({ title, message, receiverId, topic, senderId, data, debounceKey, delayMs = 3000 }) => {
//   const key = debounceKey || `${topic || receiverId}_${title}`;

//   if (debounceMap.has(key)) clearTimeout(debounceMap.get(key));

//   const timeout = setTimeout(() => {
//     exports.sendInfoNotification({ title, message, receiverId, topic, senderId, data });
//     debounceMap.delete(key);
//   }, delayMs);

//   debounceMap.set(key, timeout);
// };

// exports.scheduleSyncNotification = async (topic, delayMs = 3000) => {
//   if (debounceMap.has(topic)) clearTimeout(debounceMap.get(topic));

//   const timeout = setTimeout(() => {
//     fcm.send(topic, '', '', { type: 'sync_trigger' }, true);
//     debounceMap.delete(topic);
//   }, delayMs);

//   debounceMap.set(topic, timeout);
// };

// exports.getUserNotifications = async (userId, topics = []) => {
//   return await notification.find({
//     $or: [
//       { receiverId: userId },
//       { type: 'topic', target: { $in: topics } }
//     ]
//   }).sort({ createdAt: -1 }).limit(100);
// };