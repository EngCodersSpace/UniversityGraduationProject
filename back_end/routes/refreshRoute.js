const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/refreshController');
const {checkPermission} = require('../middleware/roleMiddleware');
const { verifyToken } = require('../middleware/authMiddleware');
router.use(verifyToken);

router.post('/create-refresh',checkPermission('refresh_states', 'write'), CRUD.upsertRefreshState);
router.get('/get-all-refresh',CRUD.getAllRefreshStates);
router.delete('/delete-refresh',checkPermission('refresh_states', 'write'), CRUD.deleteRefreshState);

module.exports = router;