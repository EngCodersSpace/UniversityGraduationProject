const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/refreshController');
const { verifyToken } = require('../middleware/authMiddleware');
// const checkRole = require('../middleware/roleMiddleware');

router.use(verifyToken);

router.post('/create-refresh', CRUD.upsertRefreshState);
router.get('/get-all-refresh',CRUD.getAllRefreshStates);
router.delete('/delete-refresh', CRUD.deleteRefreshState);

module.exports = router;