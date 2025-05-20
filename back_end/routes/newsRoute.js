// routes/newsRoutes.js
const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/newsController');
const {checkPermission , checkStudentsAccess , checkDoctorAccess,checkUserAccess} = require('../middleware/roleMiddleware');

const { verifyToken } = require('../middleware/authMiddleware');
router.use(verifyToken);

router.post('/New-With-Photo', CRUD.createNewsWithPhoto);

router.get('/Get-AllNews', CRUD.getAllNewsWithLimit);
router.get('/Get-imageOfnew', CRUD.getImageOfNews);

router.get('/Get-New/:id', CRUD.getNewsById);
router.put('/Update-New/:id', CRUD.updateNewsWithPhoto);
router.delete('/Delete-New/:id', CRUD.deleteNews);

module.exports = router;