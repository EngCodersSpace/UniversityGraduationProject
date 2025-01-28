
const { refresh_state } = require('..models'); 

exports.createRefreshState = async (req, res) => {
  try {
    const newRecord = await refresh_state.create(req.body.target, req.body.state, req.body.filter );
    return res.status(201).json({
        message:'create newRecord successfully',
        data:newRecord
    }); 
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Failed to create refresh state.' , error: error.message   });
  }
};

exports.getAllRefreshStates = async (req, res) => {
  try {
    const records = await refresh_state.findAll();
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