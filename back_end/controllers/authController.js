
// controllers/authController.js
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { doctor,user,student,section,level,study_plan } = require('../models');
// const crypto = require('crypto');
const nodemailer = require('nodemailer');
const { Op } = require('sequelize');
const { validationResult } = require('express-validator');

const SECRET_KEY = process.env.SECRET_KEY ;
const JWT_EXPIRY = '10m';
const REFRESH_SECRET_KEY = process.env.REFRESH_SECRET_KEY ;

///////////////////////////
exports.welcome = (req, res) => {
    res.status(200).json({
        message: "Welcome to our website!",
        success: true,
    });
};

///////////////////////////
exports.login = async (req, res) => {
    const { user_id, password } = req.body;
    try {
        const foundUser = await user.scope('with_hidden_data').findOne({
            where: { user_id },
            include: [
                { model: doctor, as: 'doctor' }, 
            ],
        });
        
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

        const responseUser = {
            user_id: foundUser.user_id,
            user_name: foundUser.user_name,
            date_of_birth: foundUser.date_of_birth,
            profile_picture: foundUser.profile_picture,
            collegeName: foundUser.collegeName,
            email: foundUser.email,
            permission: foundUser.permission,
            department: foundUser.doctor?.department || null,
            academic_degree: foundUser.doctor?.academic_degree || null,
            administrative_position: foundUser.doctor?.administrative_position || null,
        };

        // Send response
        res.json({
            message: "Login successful",
            accessToken,
            refreshToken,
            user: responseUser,
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
            const foundUser = await user.findOne({ where: { user_id: decoded.user_id } });

            if (!foundUser) {
                return res.status(404).json({ message: "User not found" });
            }

            if (foundUser.refreshToken !== refreshToken) {
                return res.status(403).json({ message: "Refresh token does not match" });
            }


            const accessToken = jwt.sign(
                { user_id: foundUser.user_id },
                SECRET_KEY,
                { expiresIn: '15m' } 
            );

            res.json({ accessToken });
        } catch (error) {
            console.error("Error during token refresh:", error.message);
            res.status(500).json({ message: "Internal server error", error: error.message });
        }
    });
};
///////////////////////////
exports.registerDoctor = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const {} = req.body;

    try {
       
        const newDoctor = await user.create(req.body, {
            include: [
                { model: doctor, as: 'doctor' }
            ]
        });
        
        res.status(201).json({
            message: "Student registered successfully",
            user: newDoctor,
        });

    } catch (error) {
        console.error("Error during user registration:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.registerStudent = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const {} = req.body;

    try {
       
        const newStudent = await user.create(req.body, {
            include: [
                { model: student, as: 'student' }
            ]
        });
        
        res.status(201).json({
            message: "Student registered successfully",
            user: newStudent,
        });

    } catch (error) {
        console.error("Error during user registration:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};


///////////////////////////
const sendPasswordResetEmail = async (email, resetToken) => {
    const transporter = nodemailer.createTransport({
        host: 'localhost', // MailHog or other SMTP server
        port: 1025,
        secure: false,
    });

    const resetLink = `http://yourapp.com/reset-password?token=${resetToken}`;
    const mailOptions = {
        from: 'test@example.com',
        to: email,
        subject: 'Password Reset Link',
        text: `Click the following link to reset your password. This link will expire in 10 minutes: ${resetLink}`,
    };

    await transporter.sendMail(mailOptions);
};
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

        const payload = {user_id: foundUser.user_id };
        const resetToken = jwt.sign(payload, SECRET_KEY, { expiresIn: JWT_EXPIRY });
    
        foundUser.resetToken = resetToken;
        console.log(" reset token:", resetToken);  

        foundUser.resetTokenExpiry = Date.now() + 10 * 60 * 1000;  
        const result = await foundUser.save();
        console.log("Save result:", result);  

        console.log("Generated reset token:", resetToken); 

        await sendPasswordResetEmail(foundUser.email, resetToken);

        res.status(200).json({ message: 'Password reset link sent to your email.' });


    } catch (error) {
        console.error("Error during password reset request:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};
exports.verifyResetToken = async (req, res) => {
    const { token } = req.query;    // token come to you on your email put it in the query param to compaire

    try {
        const foundUser = await user.findOne({
            where: {
                resetToken: token,
                resetTokenExpiry: { [Op.gt]: Date.now() },
            },
        });

        if (!foundUser) {
            return res.status(400).json({ message: 'Invalid or expired reset token' });
        }

        // Generate a JWT for subsequent requests
        const jwtToken = jwt.sign(
            { user_id: foundUser.user_id },SECRET_KEY,{ expiresIn: '15m' }
        );

        res.status(200).json({ token: jwtToken, message: 'Token verified successfully.' });
    } catch (error) {
        console.error("Error verifying reset token:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};
exports.resetPassword = async (req, res) => {
    try {
        // Get the JWT token from headers
        const token = req.headers.authorization.split(' ')[1];
        if (!token) {
            return res.status(401).json({ message: 'Authorization token is required.' });
        }

        // Verify the JWT token
        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        const userId = decoded.user_id;

        // Validate passwords
        const { newPassword, confirmPassword } = req.body;
        if (newPassword !== confirmPassword) {
            return res.status(400).json({ message: "Passwords do not match" });
        }

        // Find the user in the database
        const foundUser = await user.findOne({ where: { user_id: userId } });
        
        if (!foundUser) {
            return res.status(404).json({ message: "User not found" });
        }

        // Update the user's password
        foundUser.password = bcrypt.hashSync(newPassword, 10);
        foundUser.resetToken = null;
        foundUser.resetTokenExpiry = null; // Invalidate the token
        await foundUser.save();

        res.status(200).json({ message: "Password has been reset successfully." });
    } catch (error) {
        console.error("Error during password reset:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};
///////////////////////////

// Function to get the currently logged-in user based on JWT token (me) 
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








// exports.registerStudent = async (req, res) => {
//     const errors = validationResult(req);
//     if (!errors.isEmpty()) {
//         return res.status(400).json({ errors: errors.array() });
//     }
//     const {
//         user_id,
//         user_name,
//         date_of_birth,
//         profile_picture,
//         collegeName,
//         email,
//         permission,
//         password,
//         student: studentData
//     } = req.body;
//     try {
//         const existingUser = await user.findOne({ where: { user_id } });
//         const existingEmail = await user.findOne({ where: { email } });
//         if (existingUser) {
//             return res.status(400).json({ message: "User ID already exists" });
//         }
//         if (existingEmail) {
//             return res.status(400).json({ message: "Email already registered" });
//         }
//         const newUser = await user.create(
//             {
//                 user_id,
//                 user_name,
//                 date_of_birth,
//                 profile_picture,
//                 collegeName,
//                 email,
//                 password,
//                 permission,
//                 student: studentData ? {
//                     student_section_id: studentData.student_section_id,
//                     enrollment_year: studentData.enrollment_year,
//                     student_level_id: studentData.student_level_id,
//                     student_system: studentData.student_system,
//                     study_plan_id: studentData.study_plan_id,
//                 } : null,
//             },
//             {
//                 include: [{ model: student, as: 'student' }],
//             }
//         );
//         const responseUser = {
//             user_id: newUser.user_id,
//             user_name: newUser.user_name,
//             date_of_birth: newUser.date_of_birth,
//             email: newUser.email,
//             permission: newUser.permission,
//             student_section_id: newUser.student?.student_section_id || null,
//             enrollment_year: newUser.student?.enrollment_year || null,
//             student_level_id: newUser.student.student_level_id || null,
//             student_system: newUser.student.student_system || null,
//             study_plan_id: newUser.student.study_plan_id || null,   
//         };
//         res.status(201).json({
//             message: "Student registered successfully",
//             user: responseUser,
//         });

//     } catch (error) {
//         console.error("Error during user registration:", error.message);
//         res.status(500).json({ message: "Internal server error", error: error.message });
//     }
// };




