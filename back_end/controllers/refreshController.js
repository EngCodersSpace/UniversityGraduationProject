
const { refresh_state } = require('../models'); 
const crypto = require('crypto');
const { sendSystemNotification } = require('./notificationController'); // your existing system notification logic


function generateId(target, filter) {
  return `${target}-${crypto.createHash('md5').update(JSON.stringify(filter)).digest('hex')}`;
}

exports.upsertRefreshState = async (target, filter) => {
  try {
    const id = generateId(target, filter);

    const [record, created] = await refresh_state.upsert(
      { id, target, filter, updatedAt: new Date() },
      {
        returning: true,
        conflictFields: ['id'],
        update: ['updatedAt'],
      }
    );

    // Trigger a system notification for refresh
    const systemTitle = `Refresh Required: ${target}`;
    const systemMessage = `Data has changed for ${target}. Please refresh.`;

    // Example: broadcast to topic (e.g. "admin", "student-<section_id>")
    const topic = `${target}`;
    const metadata = { target, filter }; 

    await sendSystemNotification({
      title: systemTitle,
      message: systemMessage,
      target: topic, 
      sender_id: 0, 
      topicType: 'topic',
      metadata,
    });

    return { record, created };
  } catch (error) {
    throw new Error('Failed to create/update refresh state: ' + error.message);
  }
};

exports.getAllRefreshStates = async (req, res) => {
  try {
    const records = await refresh_state.findAll();
    if (records.length === 0) {
      return res.status(204).send(); 
    }
    return res.status(200).json({
        message:'get all Records successfully',
        data:records
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Failed to fetch refresh states.' ,error:error.message});
  }
};

exports.deleteRefreshState = async (req, res) => {
  try {
    const { id } = req.params;
    const record = await refresh_state.findByPk(id);
    if (!record) {
      return res.status(404).json({ error: 'Refresh state not found.' });
    }
    await record.destroy();
    return res.status(200).json({ message: 'Refresh state deleted successfully.' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Failed to delete refresh state.' });
  }
};