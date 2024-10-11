// routes/userRoute.js
const express = require('express');
const userController = require('../controllers/userController');
const router =express.Router();


// User registration route
router.post('/user/register', userController.registerUser);

// User login route (non-JWT based)
router.post('/user/login', userController.loginUser);


module.exports = router;


