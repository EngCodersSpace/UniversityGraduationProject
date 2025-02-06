
// authMiddleware.js    to verify the JWT token
const jwt = require('jsonwebtoken');
const dotenv = require("dotenv");
dotenv.config({ path: './.env' });

exports.verifyToken = (req, res, next) => {
    const bearerHeader = req.headers.authorization;
    if (!bearerHeader) {
        return res.status(401).json({ message: "Authorization header is missing" });
    }

    const token = bearerHeader.split(' ')[1];
    if (!token) {
        return res.status(401).json({ message: "Token is missing" });
    }

    try {
        const decoded = jwt.verify(token, process.env.SECRET_KEY); 
        req.user = decoded;
        next();
    } catch (err) {
        return res.status(401).json({ message: "Invalid or expired token" });
    }
};



















