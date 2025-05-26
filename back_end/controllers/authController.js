// controllers/authController.js
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const {
  doctor,
  user,
  student,
  section,
  role,
  permission,
  student_assignment,
  assignment,
  level,
  phone_number,
  study_plan,
} = require("../models");
const nodemailer = require("nodemailer");
const { validationResult } = require("express-validator");
const { Op, Sequelize } = require("sequelize");
const path = require("path");
const fs = require("fs");
const { ValidationError, UniqueConstraintError, ForeignKeyConstraintError } = require('sequelize');
const { translateText } = require("../middleware/translationServices");
const { uploadPhoto } = require("../utils/multerConfig");
// const { permission } = require("process");

const SECRET_KEY = process.env.SECRET_KEY;
const JWT_EXPIRY = "10m";
const REFRESH_SECRET_KEY = process.env.REFRESH_SECRET_KEY;

///////////////////////////
exports.welcome = (req, res) => {
  res.status(200).json({
    message: "Welcome to our website!",
    success: true,
  });
};
///////////////////////////

exports.login = async (req, res) => {
  console.log("\n__________________login__________________\n");
  const { user_id, password, fcm_token } = req.body;
  console.log("____________________________________\n");
  console.log(fcm_token, "\n");
  console.log("____________________________________\n");
  try {
    const foundUser = await user.scope("with_hidden_data").findOne({
      where: { user_id },
      include: [
        { model: doctor, as: "doctor" },
        {
          model: student,
          as: "student",
          include: [
            {
              model: level,
              as: "level",
            },
          ],
        },
        { model: section, as: "section" },

        {
          model: role,
          include: [
            {
              model: permission,
              as: "permissions",
              through: { attributes: [] },
            },
          ],
        },
      ],
    });

    if (!foundUser) {
      return res.status(401).json({ message: "User ID is not correct" });
    }

    const isMatch = await bcrypt.compare(password, foundUser.password);
    if (!isMatch) {
      return res.status(401).json({ message: "Password is not correct" });
    }

    const accessToken = jwt.sign(
      {
        user_id: foundUser.user_id,
        permission: foundUser.role.roleName,
      },
      SECRET_KEY,
      { expiresIn: "1h" }
    );

    const refreshToken = jwt.sign(
      {
        user_id: foundUser.user_id,
        permission: foundUser.role.roleName,
      },
      REFRESH_SECRET_KEY,
      { expiresIn: "1d" }
    );

    foundUser.refreshToken = refreshToken;
    foundUser.fcm_token = fcm_token;
    await foundUser.save();

    let responseUser = {};
    let user_type = null;

    if (foundUser.doctor == null) {
      responseUser = foundUser.toJSON();
      user_type = "student";
      const tempStudent = responseUser.student;
      delete responseUser.student;
      delete responseUser.doctor;
      responseUser = { ...responseUser, ...tempStudent };

      const studentAssignments = await assignment.findAll({
        where: {
          level_id: foundUser.student.level.id,
          section_id: foundUser.user_section_id,
        },
        include: [
          {
            model: student,
            through: {
              attributes: [],
              where: { student_id: foundUser.user_id },
            },
          },
        ],
      });

      totalAssignmentsCount = studentAssignments.length;
      completedAssignmentsCount = studentAssignments.filter(
        (assign) => assign.is_completed === true
      ).length;

      responseUser = {
        ...responseUser,
        completedAssignmentsCount,
        totalAssignmentsCount,
      };
    } else if (foundUser.student == null) {
      responseUser = foundUser.toJSON();
      user_type = "doctor";
      const tempDoctor = responseUser.doctor;
      delete responseUser.student;
      delete responseUser.doctor;
      responseUser = { ...responseUser, ...tempDoctor };
    }

    res.json({
      message: "Login successful",
      accessToken,
      refreshToken,
      user: responseUser,
      user_type: user_type,
    });
  } catch (error) {
    console.error("Error during login:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
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
      return res.status(401).json({ message: "Invalid refresh token" });
    }
    try {
      const foundUser = await user.findOne({
        where: { user_id: decoded.user_id },
        include: { model: role },
      });

      if (!foundUser) {
        return res.status(404).json({ message: "User not found" });
      }

      if (foundUser.refreshToken !== refreshToken) {
        return res
          .status(401)
          .json({ message: "Refresh token does not match" });
      }

      const accessToken = jwt.sign(
        {
          user_id: foundUser.user_id,
          permission: foundUser.role.roleName,
        },
        SECRET_KEY,
        {
          expiresIn: "15m",
        }
      );

      res.json({ accessToken });
    } catch (error) {
      console.error("Error during token refresh:", error.message);
      res
        .status(500)
        .json({ message: "Internal server error", error: error.message });
    }
  });
};

//  req from body (user_id , newFCM)
exports.refreshFCM=async(req,res)=>{
  try {
    const userFCM= await user.findOne({
      where:{ user_id :req.body.user_id}
    });
    await userFCM.update({ fcmToken: newFCM });

    res.status(200).json({ message: "FCM token updated successfully" });

  } catch (error) {
    console.error("Error during refresh FCM token :", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};
///////////////////////////
exports.registerDoctor = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const targetLanguage =
      req.headers["accept-language"] === "en" ? "ar" : "en";
    const translatedUserName = await translateText(
      req.body.user_name,
      req.headers["accept-language"],
      targetLanguage
    );
    const translatedCollegeName = await translateText(
      req.body.collegeName,
      req.headers["accept-language"],
      targetLanguage
    );
    const translatedAcademicDegree = await translateText(
      req.body.doctor.academic_degree,
      req.headers["accept-language"],
      targetLanguage
    );
    const translatedAdministrativePosition = await translateText(
      req.body.doctor.administrative_position,
      req.headers["accept-language"],
      targetLanguage
    );

    const userData = {
      user_id: req.body.user_id,
      user_name: {
        [req.headers["accept-language"]]: req.body.user_name,
        [targetLanguage]: translatedUserName,
      },
      user_section_id: req.body.user_section_id,
      date_of_birth: req.body.date_of_birth,
      collegeName: {
        [req.headers["accept-language"]]: req.body.collegeName,
        [targetLanguage]: translatedCollegeName,
      },
      email: req.body.email,
      password: req.body.password,
      roleId: req.body.roleId,
      phones: req.body.phones ,
      doctor: {
        academic_degree: {
          [req.headers["accept-language"]]: req.body.doctor.academic_degree,
          [targetLanguage]: translatedAcademicDegree,
        },
        administrative_position: {
          [req.headers["accept-language"]]:
            req.body.doctor.administrative_position,
          [targetLanguage]: translatedAdministrativePosition,
        },
      },
    };

    const newDoctor = await user.create(userData, {
      include: [
        {
          model: doctor,
          as: "doctor",
        },
        {
          model:phone_number , as:'phones',
        }
      ],
    });

    res.status(201).json({
      message: "Doctor registered successfully",
      user: newDoctor,
    });
  } catch (error) {
    console.error("Error during user registration:", error.message);
    if (error instanceof UniqueConstraintError) {
      return res.status(400).json({ message: 'Duplicate entry error: ' + error.message });
    }  
    if (error instanceof ForeignKeyConstraintError) {
      return res.status(400).json({ message: 'Foreign key violation: ' + error.message });
    }
    if (error instanceof ValidationError) {
      return res.status(400).json({ message: 'Validation error: ' + error.message });
    }
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};
exports.registerStudent = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const targetLanguage =
      req.headers["accept-language"] === "en" ? "ar" : "en";
    const translatedUserName = await translateText(
      req.body.user_name,
      req.headers["accept-language"],
      targetLanguage
    );
    const translatedCollegeName = await translateText(
      req.body.collegeName,
      req.headers["accept-language"],
      targetLanguage
    );
    const translatedStudentSystem = await translateText(
      req.body.student.student_system,
      req.headers["accept-language"],
      targetLanguage
    );

    const userData = {
      user_id: req.body.user_id,
      user_name: {
        [req.headers["accept-language"]]: req.body.user_name,
        [targetLanguage]: translatedUserName,
      },
      user_section_id: req.body.user_section_id,
      date_of_birth: req.body.date_of_birth,
      collegeName: {
        [req.headers["accept-language"]]: req.body.collegeName,
        [targetLanguage]: translatedCollegeName,
      },
      email: req.body.email,
      password: req.body.password,
      roleId: req.body.roleId,
      phones: req.body.phones ,
      student: {
        study_plan_id: req.body.student.study_plan_id,
        student_level_id: req.body.student.student_level_id,
        enrollment_year: req.body.student.enrollment_year,
        student_system: {
          [req.headers["accept-language"]]: req.body.student.student_system,
          [targetLanguage]: translatedStudentSystem,
        },
      },
    };

    const newStudent = await user.create(userData, {
      include: [{ model: student, as: "student" },
        {model:phone_number ,as:'phones'}
      ],
    });

    res.status(201).json({
      message: "Student registered successfully",
      user: newStudent,
    });
  } catch (error) {
    console.error("Error during user registration:", error.message);
    if (error instanceof UniqueConstraintError) {
      return res.status(400).json({ message: 'Duplicate entry error: ' + error.message });
    }  
    if (error instanceof ForeignKeyConstraintError) {
      return res.status(400).json({ message: 'Foreign key violation: ' + error.message });
    }
    if (error instanceof ValidationError) {
      return res.status(400).json({ message: 'Validation error: ' + error.message });
    }
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

exports.uploadPhotoForuser = async (req, res) => {
  try {
    const newUser = await user.findOne({
      where: { user_id: req.query.user_id },
    });

    if (!newUser) {
      return res.status(404).json({ message: "User not found." });
    }

    uploadPhoto("profile_picture", "user").single("file")(
      req,
      res,
      async (err) => {
        if (err) {
          return res
            .status(400)
            .json({
              message: "Error during photo upload.",
              error: err.message,
            });
        }

        if (!req.file) {
          return res
            .status(400)
            .json({ message: "No photo provided for upload." });
        }

        try {
          const oldFilePath = req.file.path;
          const fileExtension = path.extname(req.file.originalname);
          const newFileName = `${newUser.user_id}${fileExtension}`;
          const newFilePath = path.join(path.dirname(oldFilePath), newFileName);

          fs.renameSync(oldFilePath, newFilePath);
          newUser.profile_picture = `profile_picture/user/${newFileName}`;
          await newUser.save();

          res.status(201).json({
            message: "Photo uploaded successfully.",
            filePath: newUser.profile_picture,
          });
        } catch (error) {
          console.error("Error while uploading photo:", error.message);
          res
            .status(500)
            .json({ message: "Internal server error.", error: error.message });
        }
      }
    );
  } catch (error) {
    console.error("Error while uploading photo:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error.", error: error.message });
  }
};

exports.getImageOfUser = async (req, res) => {
  try {

      if (!req.query.user_id) {
          return res.status(400).json({message: "user id  is required" });
      }

      const ImageOfUser = await user.findOne({
          where: { user_id: req.query.user_id },
      });

      if (ImageOfUser.length === 0) {
        return res.status(204).json();
      }

      if (!ImageOfUser) {
          return res.status(404).json({ success: false, message: "No image found for the specified user" });
      }
      const imagePath = path.join(__dirname  , '..',"storage" ,ImageOfUser.profile_picture);
      console.log('\n \n path of image:',imagePath)
      res.sendFile(imagePath);
  } catch (error) {
      console.error("Error fetching new's image:", error);
      res.status(500).json({message: "An error occurred while fetching new's image", error: error.message });
  }
};


// Function to get the currently logged-in user 
exports.getCurrentUser = async (req, res) => {
  try {
      const foundUser = await user.scope("with_hidden_data").findOne(
        { where: { user_id: req.user.user_id } ,
        include: [
          { model: doctor, as: "doctor" },
          {
            model: student,
            as: "student",
            include: [
              {
                model: level,
                as: "level",
              },
            ],
          },
          { model: section, as: "section" },
  
          {
            model: role,
            include: [
              {
                model: permission,
                as: "permissions",
                through: { attributes: [] },
              },
            ],
          },
        ],
      });

      if (!foundUser) {
          return res.status(404).json({ message: "User not found" });
      }


      let responseUser = {};
    let user_type = null;

    if (foundUser.doctor == null) {
      responseUser = foundUser.toJSON();
      user_type = "student";
      const tempStudent = responseUser.student;
      delete responseUser.student;
      delete responseUser.doctor;
      responseUser = { ...responseUser, ...tempStudent };

      const studentAssignments = await assignment.findAll({
        where: {
          level_id: foundUser.student.level.id,
          section_id: foundUser.user_section_id,
        },
        include: [
          {
            model: student,
            through: {
              attributes: [],
              where: { student_id: foundUser.user_id },
            },
          },
        ],
      });

      totalAssignmentsCount = studentAssignments.length;
      completedAssignmentsCount = studentAssignments.filter(
        (assign) => assign.is_completed === true
      ).length;

      responseUser = {
        ...responseUser,
        completedAssignmentsCount,
        totalAssignmentsCount,
      };
    } else if (foundUser.student == null) {
      responseUser = foundUser.toJSON();
      user_type = "doctor";
      const tempDoctor = responseUser.doctor;
      delete responseUser.student;
      delete responseUser.doctor;
      responseUser = { ...responseUser, ...tempDoctor };
    }

    res.json({
      message: "Get Currrent User Data  successful",
      user: responseUser,
      user_type: user_type,
    });

  } catch (error) {
      console.error("Error fetching user:", error.message);
      res.status(500).json({ message: "Internal server error", error: error.message });
  }
};

///////////////////////////
const sendPasswordResetEmail = async (email, resetToken) => {
  const transporter = nodemailer.createTransport({
    host: "localhost", // MailHog or other SMTP server
    port: 1025,
    secure: false,
  });

  const resetLink = `http://yourapp.com/reset-password?token=${resetToken}`;
  const mailOptions = {
    from: "test@example.com",
    to: email,
    subject: "Password Reset Link",
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

    const payload = { user_id: foundUser.user_id };
    const resetToken = jwt.sign(payload, SECRET_KEY, { expiresIn: JWT_EXPIRY });

    foundUser.resetToken = resetToken;
    console.log(" reset token:", resetToken);

    foundUser.resetTokenExpiry = Date.now() + 10 * 60 * 1000;
    const result = await foundUser.save();
    console.log("Save result:", result);

    console.log("Generated reset token:", resetToken);

    await sendPasswordResetEmail(foundUser.email, resetToken);

    res
      .status(200)
      .json({ message: "Password reset link sent to your email." });
  } catch (error) {
    console.error("Error during password reset request:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};
exports.verifyResetToken = async (req, res) => {
  const { token } = req.query; // token come to you on your email put it in the query param to compaire

  try {
    const foundUser = await user.findOne({
      where: {
        resetToken: token,
        resetTokenExpiry: { [Op.gt]: Date.now() },
      },
    });

    if (!foundUser) {
      return res
        .status(400)
        .json({ message: "Invalid or expired reset token" });
    }

    // Generate a JWT for subsequent requests
    const jwtToken = jwt.sign({ user_id: foundUser.user_id }, SECRET_KEY, {
      expiresIn: "15m",
    });

    res
      .status(200)
      .json({ token: jwtToken, message: "Token verified successfully." });
  } catch (error) {
    console.error("Error verifying reset token:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};
exports.resetPassword = async (req, res) => {
  try {
    // Get the JWT token from headers
    // const token = req.headers.authorization.split(" ")[1];
    // if (!token) {
    //   return res
    //     .status(401)
    //     .json({ message: "Authorization token is required." });
    // }
    // // Verify the JWT token
    // const decoded = jwt.verify(token, process.env.SECRET_KEY);
    // const userId1 = decoded.user_id;

    const userId = req.user.user_id;

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
    foundUser.password = newPassword;
    foundUser.resetToken = null;
    foundUser.resetTokenExpiry = null; // Invalidate the token
    await foundUser.save();

    res.status(200).json({ message: "Password has been reset successfully." });
  } catch (error) {
    console.error("Error during password reset:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

///////////////////////////

// focus on resetPassword?

exports.changePass = async (req, res) => {
  try {
    const { oldPassword, newPassword, confirmPassword } = req.body;

    if (!req.headers.authorization) {
      return res
        .status(401)
        .json({ message: "Authorization token is required." });
    }
    console.log(req.headers);
    const token = req.headers.authorization.split(" ")[1];
    const decoded = jwt.verify(token, process.env.SECRET_KEY);
    const userId = decoded.user_id;

    // const userId = req.user.user_id ;

    const foundUser = await user.findOne({
      where: { user_id: userId },
      attributes: ["user_id", "password"],
    });

    if (!foundUser) {
      return res.status(404).json({ message: "User not found " });
    }

    const isMatch = await bcrypt.compare(oldPassword, foundUser.password);
    if (!isMatch) {
      return res
        .status(422)
        .json({ message: "Password is not Match with password in DATABASE" });
    }

    if (newPassword !== confirmPassword) {
      return res
        .status(422)
        .json({ message: "New Password Do's not Match Confirm Password" });
    }

    foundUser.password = newPassword;
    foundUser.resetToken = null;
    foundUser.resetTokenExpiry = null;
    await foundUser.save();

    res.status(200).json({
      message: "change Password successful",
    });
  } catch (error) {
    console.error("Error during changing password:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

exports.logout = async (req, res) => {
  try {
    const foundUser = await user.findOne({
      where: { user_id: req.query.user_id },
    });

    if (!foundUser) {
      return res.status(404).json({ message: "User not found" });
    }

    foundUser.refreshToken = null;

    await foundUser.save();

    res.status(200).json({ message: "Logout successful" });
  } catch (error) {
    console.error("Error during logout:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};
