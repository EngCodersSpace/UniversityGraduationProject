
// controllers/authController.js
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { user } = require('../models');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
const { Op } = require('sequelize');

const SECRET_KEY = process.env.SECRET_KEY ;
const REFRESH_SECRET_KEY = process.env.REFRESH_SECRET_KEY ;

// Function to handle user login
// exports.login = async (req, res) => {
//     const { user_id, password } = req.body; 
//     try {
//         const foundUser = await user.findOne({ where: { user_id } });
//         if (!foundUser) {
//             return res.status(401).json({ message: "User ID is not correct" });
//         }

//         const isMatch = await bcrypt.compare(password, foundUser.password);
//         if (!isMatch) {
//             return res.status(401).json({ message: "Password is not correct" });
//         }

//         const token = jwt.sign({ 
//             user_id: foundUser.user_id, 
//             permission: foundUser.permission 
//         }, SECRET_KEY, { expiresIn: '1h' });

//         res.json({ 
//             token,
//             user: {
//                 user_id: foundUser.user_id,
//                 permission: foundUser.permission
//             }
//         });
//     } catch (error) {
//         console.error("Error during login:", error.message);
//         res.status(500).json({ message: "Internal server error", error: error.message });
//     }
// };

exports.login = async (req, res) => {
    const { user_id, password } = req.body;
    try {
        const foundUser = await user.findOne({ where: { user_id } });
        if (!foundUser) {
            return res.status(401).json({ message: "User ID is not correct" });
        }

        const isMatch = await bcrypt.compare(password, foundUser.password);
        if (!isMatch) {
            return res.status(401).json({ message: "Password is not correct" });
        }

        // إصدار accessToken
        const accessToken = jwt.sign({
            user_id: foundUser.user_id,
            permission: foundUser.permission
        }, SECRET_KEY, { expiresIn: '1h' });

        // إصدار refreshToken
        const refreshToken = jwt.sign({
            user_id: foundUser.user_id
        }, REFRESH_SECRET_KEY, { expiresIn: '7d' }); // صالح لمدة 7 أيام

        // حفظ refreshToken في قاعدة البيانات أو ذاكرة (اختياري)
        foundUser.refreshToken = refreshToken;
        await foundUser.save();

        res.json({
            accessToken,
            refreshToken,
            user: {
                user_id: foundUser.user_id,
                permission: foundUser.permission
            }
        });
    } catch (error) {
        console.error("Error during login:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.refreshToken = async (req, res) => {
    const { refreshToken } = req.body;

    if (!refreshToken) {
        return res.status(401).json({ message: "Refresh token is missing" });
    }

    try {
        // التحقق من refreshToken وفك شفرته
        const decoded = jwt.verify(refreshToken, REFRESH_SECRET_KEY);

        // البحث عن المستخدم بناءً على user_id الموجود في refreshToken
        const foundUser = await user.findOne({ where: { user_id: decoded.user_id, refreshToken } });
        if (!foundUser) {
            return res.status(403).json({ message: "Invalid refresh token" });
        }

        // إصدار accessToken جديد
        const newAccessToken = jwt.sign({
            user_id: foundUser.user_id,
            permission: foundUser.permission
        }, SECRET_KEY, { expiresIn: '1h' });

        res.json({
            accessToken: newAccessToken
        });

    } catch (error) {
        console.error("Error during refresh token:", error.message);
        res.status(403).json({ message: "Invalid or expired refresh token", error: error.message });
    }
};

// Function to verify the token
exports.verifyToken = (req, res) => {
    jwt.verify(req.token, SECRET_KEY, (err, data) => {
        if (err) {
            return res.sendStatus(403);
        }
        res.json({ message: "verifyOk", data });
    });
};

exports.registerUser = async (req, res) => {
    const { user_id, user_name, date_of_birth, email, password, permission } = req.body;

    try {
        const existingUser = await user.findOne({ where: { user_id } });
        const existingEmail = await user.findOne({ where: { email } });

        if (existingUser) {
            return res.status(400).json({ message: "User ID already exists" });
        }

        if (existingEmail) {
            return res.status(400).json({ message: "Email already registered" });
        }

        const newUser = await user.create({
            user_id,
            user_name,
            date_of_birth, 
            email,
            password, 
            permission, 
        });

        res.status(201).json({ 
            message: "User registered successfully", 
            user: {
                user_id: newUser.user_id,
                user_name: newUser.user_name,
                email: newUser.email,
                date_of_birth: newUser.date_of_birth,
                permission: newUser.permission
            }
        });

    } catch (error) {
        console.error("Error during user registration:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

const sendPasswordResetEmail = async (email, resetToken) => {
    const transporter = nodemailer.createTransport({
        host: 'localhost', // عنوان خادم SMTP المحلي
        port: 1025, // المنفذ الافتراضي لـ MailHog
        secure: false, // يجب أن تكون false عند استخدام المنفذ 1025
    });

    const mailOptions = {
        from: 'test@example.com', // عنوان بريد إلكتروني وهمي
        to: email,
        subject: 'Password Reset Request',
        text: `You requested a password reset. Click the link below to reset your password:
        http://yourdomain.com/reset-password/${resetToken}`
    };

    await transporter.sendMail(mailOptions);
};

exports.requestPasswordReset = async (req, res) => {
    const { email } = req.body;
    try {
        const foundUser = await user.findOne({ where: { email } });
        if (!foundUser) {
            return res.status(404).json({ message: "Email not found" });
        }

        const resetToken = crypto.randomBytes(32).toString('hex');
        const resetTokenExpiry = Date.now() + 3600000; // صالح لمدة ساعة

        foundUser.resetToken = resetToken;
        foundUser.resetTokenExpiry = resetTokenExpiry;
        await foundUser.save();

        await sendPasswordResetEmail(foundUser.email, resetToken);
        res.status(200).json({ message: 'Password reset link sent to your email.' });
    } catch (error) {
        console.error("Error during password reset request:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.resetPassword = async (req, res) => {
    const { token, newPassword } = req.body;
    try {
        const foundUser = await user.findOne({
            where: {
                resetToken: token,
                resetTokenExpiry: { [Op.gt]: Date.now() }
            }
        });

        if (!foundUser) {
            return res.status(400).json({ message: "Invalid or expired token" });
        }

        // تشفير كلمة المرور الجديدة
        foundUser.password = bcrypt.hashSync(newPassword, 10);
        foundUser.resetToken = null;
        foundUser.resetTokenExpiry = null;
        await foundUser.save();

        res.status(200).json({ message: "Password has been reset successfully." });
    } catch (error) {
        console.error("Error during password reset:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};


// Function to get the currently logged-in user based on JWT token
exports.getCurrentUser = (req, res) => {
    // الحصول على التوكن من الهيدر (الطلب)
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ message: "Access token is missing" });
    }

    // التحقق من التوكن وفك شفرته
    jwt.verify(token, SECRET_KEY, async (err, decoded) => {
        if (err) {
            return res.status(403).json({ message: "Invalid token" });
        }

        try {
            // البحث عن المستخدم بناءً على user_id الموجود في التوكن
            const foundUser = await user.findOne({ where: { user_id: decoded.user_id } });

            if (!foundUser) {
                return res.status(404).json({ message: "User not found" });
            }

            // إرسال بيانات المستخدم
            res.json({
                user_id: foundUser.user_id,
                user_name: foundUser.user_name,
                email: foundUser.email,
                permission: foundUser.permission
            });
        } catch (error) {
            console.error("Error fetching user:", error.message);
            res.status(500).json({ message: "Internal server error", error: error.message });
        }
    });
};







