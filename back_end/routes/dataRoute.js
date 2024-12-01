
const express = require('express');
const { getAllData } = require('../controllers/dataControll');
const router = express.Router();
const cors = require('cors');

router.get('/all-data', cors(corsOptions), getAllData); 

module.exports = router;
