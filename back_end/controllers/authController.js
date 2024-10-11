
// controllers/authController.js
// const { registerUser, loginUser } = require('./userController'); 

// exports.register = async (req, res) => {
//     try {
//         const newUser = await registerUser(req.body);
//         res.status(201).send({ message: 'User registered successfully', user: newUser });
//     } catch (error) {
//         res.status(400).send({ error: error.message });
//     }
// };

// exports.login = async (req, res) => {
//     try {
//         const user = await loginUser(req.body); 
//         res.status(200).json(user); 
//     } catch (error) {
//         res.status(400).json({ error: error.message });
//     }
// };



// controllers/authController.js



const jwt = require('jsonwebtoken');
const { user } = require('../models'); 
const bcrypt = require('bcrypt');
const SECRET_KEY = process.env.SECRET_KEY || "mySuperSecretKey1234567890123456" ; 

function generateToken(params = {}) {
    return jwt.sign(params,SECRET_KEY , {
        expiresIn: 78300, // مدة انتهاء الصلاحية (يمكن تعديلها حسب الحاجة)
    });
}

module.exports = {
    async login(req, res) {
        const { id, password, islogged } = req.body; // التحقق من user_id بدلاً من email

        try {
            const userRecord = await user.findOne({ where: { user_id: id } });

            // التحقق من وجود المستخدم
            if (!userRecord) {
                return res.status(400).send({
                    status: 0,
                    message: 'User ID or password is incorrect!',
                    user: {}
                });
            }

            // التحقق من صحة كلمة المرور
            if (!bcrypt.compareSync(password, userRecord.password)) {
                return res.status(400).send({
                    status: 0,
                    message: 'User ID or password is incorrect!',
                    user: {}
                });
            }

            const user_id = userRecord.user_id; // استخدام user_id من الجدول

            // تحديث حالة تسجيل الدخول (islogged)
            await user.update({
                islogged
            }, {
                where: {
                    id: user_id
                }
            });

            userRecord.password = undefined; // منع عرض كلمة المرور في الاستجابة

            // توليد التوكن
            const token = generateToken({ user_id: userRecord.user_id });

            // الاستجابة الناجحة
            return res.status(200).send({
                status: 1,
                message: "User logged in successfully!",
                user: userRecord,
                token
            });

        } catch (error) {
            return res.status(500).send({
                status: 0,
                message: 'Server error',
                error: error.message
            });
        }
    }
   
};





// async login1(req, res) {
//     const { id, password } = req.body;  

//     try {
//         const userRecord = await user.findOne({ where: { user_id: id } });
//         if (!userRecord) {
//             console.log("User not found"); // تتبع لمشكلة المستخدم غير موجود
//             return res.status(401).json({ message: "User not found" });
//         }
    
//         const isMatch = await bcrypt.compare(password, userRecord.password);
//         if (!isMatch) {
//             console.log("Password does not match"); // تتبع لمشكلة المطابقة
//             return res.status(401).json({ message: "Invalid password" });
//         }
    
//         const token = jwt.sign(
//             { id: userRecord.user_id, permission: userRecord.permission },
//             SECRET_KEY,
//             { expiresIn: '1h' }
//         );

//         res.json({ token });
//     } 
    
//     catch (error) {
//         console.error("Error in login process:", error); // تتبع للمشكلة
//         res.status(500).json({ message: "Server error", error: error.message });
//     }
    
// },







// const login = (req, res) => {
//     const user = {
//         username: "ahmed",
//         password: 'password123'
//     };

//     jwt.sign({ user }, SECRET_KEY, (err, token) => {
//         if (err) {
//             return res.status(401).json({
//                 message: "username or password is not correct"
//             });
//         }
//         res.json({ token });
//     });
// };

// const verifyTokenController =  (req, res) => {
//     jwt.verify(req.token, SECRET_KEY, (err, data) => {
//         if (err) {
//             return res.sendStatus(403);
//         }
//         res.json({
//             message: "Token verification successful",
//             data
//         });
//     });
// };

// async verifyTokenController(req, res) {
//     jwt.verify(req.token, SECRET_KEY, (err, data) => {
//         if (err) {
//             return res.sendStatus(403);
//         }
//         res.json({
//             message: "Token verification successful",
//             data
//         });
//     });
// }






