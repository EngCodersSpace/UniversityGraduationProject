// routes/authRoute.js

const express = require('express');
const router = express.Router();


const authController = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');

// Route for user login
router.post('/login2', authController.login);

// Route for token verification
router.post('/login/authToken', authMiddleware.verifyToken, authController.verifyToken);

router.post('/register', authController.registerUser)


// Route لطلب استعادة كلمة المرور
router.post('/request-password-reset', authController.requestPasswordReset);

// Route لإعادة تعيين كلمة المرور
router.post('/reset-password', authController.resetPassword);


// إضافة المسار لعرض بيانات المستخدم المسجل دخوله حالياً
router.get('/me', authMiddleware.verifyToken, authController.getCurrentUser);

//To refresh Token
router.post('refresh', authController.refreshToken);


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





