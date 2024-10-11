// middleware/authMiddleware.js
const jwt = require('jsonwebtoken');
// const { user } = require('../models'); 
const SECRET_KEY = process.env.SECRET_KEY || "mySuperSecretKey1234567890123456";  


module.exports = (req, res, next) => {
    const authHeader = req.headers.authorization;

    if (!authHeader) {
        return res.status(401).send({ error: 'No token provider' });
    }
    const parts = authHeader.split(' ');

    if (!parts.length == 2) {
        return res.status(401).send({ error: 'Token error!' });
    }

    const [scheme, token] = parts;

    if (!/^Bearer$/i.test(scheme)) {
        return res.status(401).send({ error: 'Token malFormatted' });
    }

    jwt.verify(token, SECRET_KEY, (err, decoded) => {
        if (err) return res.status(401).send({ error: 'Token invalid' });

        req.userId = decoded.id;
        console.log(decoded.id)

        return next();
    });

};











// const jwt = require('jsonwebtoken');
// const { user } = require('../models'); 
// const SECRET_KEY = process.env.SECRET_KEY || 'mySuperSecretKey1234567890123456';  

// module.exports = {
     
//     async authenticate(req, res, next) {
//     const token = req.header('Authorization').split(" ")[1];

//     if (!token) {
//         return res.status(401).json({ message: "Access denied. No token provided." });
//     }

//     try {
//         const decoded = jwt.verify(token, SECRET_KEY); 
//         const userRecord = await user.findOne({ where: { user_id: decoded.id } }); 

//         if (!userRecord) {
//             return res.status(401).json({ message: "User not found." });
//         }

//         req.user = userRecord; 
//         next(); 
//     } catch (err) {
//         res.status(400).json({ message: "Invalid token." });
//     }
//     }
// };









// const jwt = require('jsonwebtoken');
// const { user } = require('../models');

// const SECRET_KEY = process.env.SECRET_KEY || 'mySuperSecretKey1234567890123456';  

// // exports.auth = async (req, res, next) => {
// //     const token = req.header('Authorization')?.split(' ')[1]; 
// //     if (!token) {
// //         return res.status(401).send({ message: 'Access Denied' });
// //     }
// //     try {
// //         const verified = jwt.verify(token, SECRET_KEY);
// //         req.user = await user.findByPk(verified.id);
// //         if (!req.user) {
// //             return res.status(401).send({ message: 'Invalid Token' });
// //         }
// //         next();
// //     } catch (error) {
// //         res.status(400).send({ message: 'Invalid Token' });
// //     }
// // };

// // middleware/verifyToken.js

// function verifyToken(req, res, next) {
//     const bearerHeader = req.headers['authorization'];
//     if (typeof bearerHeader !== 'undefined') {
//         const bearer = bearerHeader.split(' ');
//         const token = bearer[1];
//         req.token = token;
//         next();
//     } else {
//         res.sendStatus(403);
//     }
// }

// module.exports = verifyToken;

















