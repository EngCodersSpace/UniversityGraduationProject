
const express = require('express');
const { getAllData } = require('../controllers/dataControll');
const router = express.Router();

router.get('/all-data', getAllData); 

module.exports = router;
