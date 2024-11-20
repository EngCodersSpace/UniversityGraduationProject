
// controllers/authController.js
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { doctor,user,student } = require('../models');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
const { Op } = require('sequelize');
const { validationResult } = require('express-validator');


const SECRET_KEY = process.env.SECRET_KEY ;
const REFRESH_SECRET_KEY = process.env.REFRESH_SECRET_KEY ;

exports.login = async (req, res) => {
    const { user_id, password } = req.body;
    if (!user_id) {
        return res.status(400).json({ message: 'User ID is required' });
    }
    if (!password) {
        return res.status(400).json({ message: 'Password is required' });
    }
    try {
        const foundUser = await user.scope('with_hidden_data').findOne({ where: { user_id } });
        if (!foundUser) {
            return res.status(401).json({ message: "User ID is not correct" });
        }
        const isMatch = await bcrypt.compare(password, foundUser.password);
        if (!isMatch) {
            return res.status(401).json({ message: "Password is not correct" });
        }
        const accessToken = jwt.sign({
            user_id: foundUser.user_id,
            permission: foundUser.permission
        }, SECRET_KEY, { expiresIn: '1h' });

        const refreshToken = jwt.sign({
            user_id: foundUser.user_id
        }, REFRESH_SECRET_KEY, { expiresIn: '7d' }); 

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
        return res.status(401).json({ message: "Refresh token is required" });
    }

    jwt.verify(refreshToken, REFRESH_SECRET_KEY, async (err, decoded) => {
        if (err) {
            console.log("Token verification error:", err.message);
            return res.status(403).json({ message: "Invalid refresh token" });
        }
        try {
            // البحث عن المستخدم بناءً على user_id في التوكن
            const foundUser = await user.findOne({ where: { user_id: decoded.user_id } });

            if (!foundUser) {
                return res.status(404).json({ message: "User not found" });
            }

            // إنشاء accessToken جديد
            const accessToken = jwt.sign(
                { user_id: foundUser.user_id },
                SECRET_KEY,
                { expiresIn: '15m' } // صلاحية لمدة 15 دقيقة
            );

            res.json({ accessToken });
        } catch (error) {
            console.error("Error during token refresh:", error.message);
            res.status(500).json({ message: "Internal server error", error: error.message });
        }
    });
};


exports.registerDoctor = async (req, res) => {
    // Handle validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const { user_id, user_name, date_of_birth, email, password, permission, doctor: doctorData } = req.body;

    try {
        const existingUser = await user.findOne({ where: { user_id } });
        const existingEmail = await user.findOne({ where: { email } });

        if (existingUser) {
            return res.status(400).json({ message: "User ID already exists" });
        }

        if (existingEmail) {
            return res.status(400).json({ message: "Email already registered" });
        }

        const newUser = await user.create(
            {
                user_id,
                user_name,
                date_of_birth,
                email,
                password,
                permission,
                doctor: doctorData ? {
                    department: doctorData.department,
                    academic_degree: doctorData.academic_degree,
                    administrative_position: doctorData.administrative_position,
                } : null,
            },
            {
                include: [{ model: doctor, as: 'doctor' }],
            }
        );
        const responseUser = {
            user_id: newUser.user_id,
            user_name: newUser.user_name,
            date_of_birth: newUser.date_of_birth,
            email: newUser.email,
            permission: newUser.permission,
            doctor: newUser.doctor
                ? {
                    department: newUser.doctor.department,
                    academic_degree: newUser.doctor.academic_degree,
                    administrative_position: newUser.doctor.administrative_position,
                }
                : null,
        };
        
        res.status(201).json({
            message: "Doctor registered successfully",
            user: responseUser,
        });
        
    } catch (error) {
        console.error("Error during user registration:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};


exports.registerStudent = async (req, res) => {
    // Handle validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const { user_id, user_name, date_of_birth, email, password, permission, student: studentData } = req.body;

    try {
        const existingUser = await user.findOne({ where: { user_id } });
        const existingEmail = await user.findOne({ where: { email } });

        if (existingUser) {
            return res.status(400).json({ message: "User ID already exists" });
        }

        if (existingEmail) {
            return res.status(400).json({ message: "Email already registered" });
        }

        const newUser = await user.create(
            {
                user_id,
                user_name,
                date_of_birth,
                email,
                password,
                permission,
                student: studentData ? {
                    student_section: studentData.student_section,
                    enrollment_year: studentData.enrollment_year,
                    student_level: studentData.student_level,
                    student_system: studentData.student_system,
                    profile_picture: studentData.profile_picture,
                    study_plan_id: studentData.study_plan_id,
                } : null,
            },
            {
                include: [{ model: student, as: 'student' }],
            }
        );
        const responseUser = {
            user_id: newUser.user_id,
            user_name: newUser.user_name,
            date_of_birth: newUser.date_of_birth,
            email: newUser.email,
            permission: newUser.permission,
            student: newUser.student
                ? {
                    student_section: newUser.student.student_section,
                    enrollment_year: newUser.student.enrollment_year,
                    student_level: newUser.student.student_level,
                    student_system: newUser.student.student_system,
                    profile_picture: newUser.student.profile_picture,
                    study_plan_id: newUser.student.study_plan_id,
                }
                : null,
        };

        // Send the response
        res.status(201).json({
            message: "Student registered successfully",
            user: responseUser,
        });
    } catch (error) {
        console.error("Error during user registration:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};



// const sendPasswordResetEmail = async (email, resetToken) => {
//     const transporter = nodemailer.createTransport({
//         host: 'localhost', // عنوان خادم SMTP المحلي
//         port: 1025, // المنفذ الافتراضي لـ MailHog
//         secure: false, // يجب أن تكون false عند استخدام المنفذ 1025
//     });

//     const mailOptions = {
//         from: 'test@example.com', // عنوان بريد إلكتروني وهمي
//         to: email,
//         subject: 'Password Reset Request',
//         text: `You requested a password reset. Click the link below to reset your password:
//         http://yourdomain.com/reset-password/${resetToken}`
//     };

//     await transporter.sendMail(mailOptions);
// };



const sendPasswordResetEmail = async (email, resetCode) => {
    const transporter = nodemailer.createTransport({
        host: 'localhost', // MailHog or other SMTP server
        port: 1025,
        secure: false,
    });

    const mailOptions = {
        from: 'test@example.com',
        to: email,
        subject: 'Password Reset Code',
        text: `Your password reset code is: ${resetCode}. It will expire in 10 minutes.`
    };

    await transporter.sendMail(mailOptions);
};

// exports.requestPasswordReset = async (req, res) => {
//     const errors = validationResult(req);
//     if (!errors.isEmpty()) {
//         return res.status(400).json({ errors: errors.array() });
//     }
//     const { email } = req.body;
//     try {
//         const foundUser = await user.findOne({ where: { email } });
//         if (!foundUser) {
//             return res.status(404).json({ message: "Email not found" });
//         }
//         const resetToken = crypto.randomBytes(32).toString('hex');
//         const resetTokenExpiry = Date.now() + 3600000; 

//         foundUser.resetToken = resetToken;
//         foundUser.resetTokenExpiry = resetTokenExpiry;
//         await foundUser.save();

//         await sendPasswordResetEmail(foundUser.email, resetToken);
//         res.status(200).json({ message: 'Password reset link sent to your email.' });
//     } catch (error) {
//         console.error("Error during password reset request:", error.message);
//         res.status(500).json({ message: "Internal server error", error: error.message });
//     }
// };


exports.requestPasswordReset = async (req, res) => {
    const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }
    const { email } = req.body;

    try {
        const foundUser = await user.findOne({ where: { email } });
        if (!foundUser) {
            return res.status(404).json({ message: "Email not found" });
        }

        const resetCode = Math.floor(100000 + Math.random() * 900000); // 6-digit numeric code
        const resetCodeExpiry = Date.now() + 10 * 60 * 1000; // 10 minutes expiry

        foundUser.resetToken = resetCode.toString();
        foundUser.resetTokenExpiry = resetCodeExpiry;
        await foundUser.save();

        await sendPasswordResetEmail(foundUser.email, resetCode);
        res.status(200).json({ message: 'Password reset code sent to your email.' });
    } catch (error) {
        console.error("Error during password reset request:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};



// exports.resetPassword = async (req, res) => {
//     const errors = validationResult(req);
//     if (!errors.isEmpty()) {
//         return res.status(400).json({ errors: errors.array() });
//     }
//     const { token, newPassword } = req.body;
//     try {
//         const foundUser = await user.findOne({
//             where: {
//                 resetToken: token,
//                 resetTokenExpiry: { [Op.gt]: Date.now() }
//             }
//         });

//         if (!foundUser) {
//             return res.status(400).json({ message: "Invalid or expired token" });
//         }

//         // تشفير كلمة المرور الجديدة
//         foundUser.password = bcrypt.hashSync(newPassword, 10);
//         foundUser.resetToken = null;
//         foundUser.resetTokenExpiry = null;
//         await foundUser.save();

//         res.status(200).json({ message: "Password has been reset successfully." });
//     } catch (error) {
//         console.error("Error during password reset:", error.message);
//         res.status(500).json({ message: "Internal server error", error: error.message });
//     }
// };

exports.resetPassword = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    const { code, newPassword, confirmPassword } = req.body;

    if (newPassword !== confirmPassword) {
        return res.status(400).json({ message: "Passwords do not match" });
    }

    try {
        const foundUser = await user.findOne({
            where: {
                resetToken: code,
                resetTokenExpiry: { [Op.gt]: Date.now() },
            }
        });

        if (!foundUser) {
            return res.status(400).json({ message: "Invalid or expired code" });
        }

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



// Function to get the currently logged-in user based on JWT token  me
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









