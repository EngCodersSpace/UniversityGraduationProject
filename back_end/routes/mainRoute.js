const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.get('/', authController.welcome);

module.exports = router;





