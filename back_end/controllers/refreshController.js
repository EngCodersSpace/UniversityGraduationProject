// refreshController.js
const { refresh_state } = require('../models'); 
const crypto = require('crypto');
const { sendSystemNotification ,} = require('./notificationController'); 
// const {convertToFcmCondition}=require('../utils/notificationUtils')

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

    // const condition =`(student in topics) && (section_${filter.section_id} in topics)  &&  (level_${filter.level_id} in topics)`;
    const condition =`('all' in topics)`;
    console.log('\n \n condition (sync)',condition , '\n \n ');

    await sendSystemNotification({
      topic_name:condition,
      metadata: {
        target:target,
        filter:filter
      },
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