const express = require('express');
const router = express.Router();


const controller= require('../controllers/easyController')

router.get("/num",controller.get1)


module.exports = router;