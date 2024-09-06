const express = require('express');
const studentController = require('../controllers/studentController');
const router = express.Router();

router.post('/students', studentController.createStudent);

// Additional routes...

module.exports = router;


