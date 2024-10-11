// routes/authRoute.js

const express = require('express');
const router = express.Router();
const authenticate = require('../middleware/authMiddleware'); 
const  {login } = require('../controllers/authController'); 


router.post('/login', login.login);


router.get('/dashboard', authenticate, (req, res) => {
    res.json({ message: `Welcome, ${req.user.user_name}` }); 
});

module.exports = router;









// const express = require('express');
// const router = express.Router();

// const authController = require('../controllers/authController');
// // Route for login ( using JWT - auth)
// router.post('/login',authController.verifyTokenController,authController.login);
// module.exports = router;



// const { login, verifyTokenController } = require('../controllers/authController');
// const verifyToken = require('../middleware/authMiddleware');
// router.post('/login', login.login);
// router.post('/verifyToken', verifyToken.verifyToken, verifyTokenController.verifyTokenController);





