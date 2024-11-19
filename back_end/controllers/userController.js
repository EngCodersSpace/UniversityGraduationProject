// controllers/userController.js
const bcrypt = require('bcrypt');
const { user, doctor , student } = require('../models'); 


exports.getUserById = async (req, res) => {
    const { id } = req.params;
    try {
        const foundUser = await user.findByPk(id);
        if (!foundUser) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.status(200).json(foundUser);
    } catch (error) {
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

exports.updateUser = async (req, res) => {
    const { id } = req.params;
    const { user_name, email, password, date_of_birth, permission } = req.body;
    try {
        const foundUser = await user.findByPk(id);
        if (!foundUser) {
            return res.status(404).json({ message: 'User not found' });
        }

        foundUser.user_name = user_name || foundUser.user_name;
        foundUser.email = email || foundUser.email;
        if (password) {
            foundUser.password = bcrypt.hashSync(password, 10); // تشفير كلمة المرور الجديدة
        }
        foundUser.date_of_birth = date_of_birth || foundUser.date_of_birth;
        foundUser.permission = permission || foundUser.permission;

        await foundUser.save();

        res.status(200).json({ message: 'User updated successfully', user: foundUser });
    } catch (error) {
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

exports.deleteUser = async (req, res) => {
    const { id } = req.params;
    try {
        const foundUser = await user.findByPk(id);
        if (!foundUser) {
            return res.status(404).json({ message: 'User not found' });
        }

        await foundUser.destroy();
        res.status(200).json({ message: 'User deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

exports.getAllUsers = async (req, res) => {
    try {
        const users = await user.findAll();
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


exports.getDoctorById = async (req, res) => {
    const { id: user_id } = req.params;

    try {
        const foundUser = await user.findOne({
            where: { user_id },
            include: [{ model: doctor, as: 'doctor' }],
        });

        if (!foundUser || !foundUser.doctor) {
            return res.status(404).json({ message: "Doctor not found" });
        }

        res.status(200).json(foundUser);
    } catch (error) {
        console.error("Error fetching doctor:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};


exports.updateDoctor = async (req, res) => {
    const {  id: user_id  } = req.params;
    const { user_name, date_of_birth, email, doctor: doctorData } = req.body;

    try {
        const foundUser = await user.findOne({
            where: { user_id },
            include: [{ model: doctor, as: 'doctor' }],
        });

        if (!foundUser || !foundUser.doctor) {
            return res.status(404).json({ message: "Doctor not found" });
        }

        // تحديث بيانات المستخدم
        await foundUser.update({
            user_name,
            date_of_birth,
            email,
        });

        // تحديث بيانات الدكتور
        if (doctorData) {
            await foundUser.doctor.update({
                doctor_name: doctorData.doctor_name,
                department: doctorData.department,
                academic_degree: doctorData.academic_degree,
                administrative_position: doctorData.administrative_position,
            });
        }

        res.status(200).json({ message: "Doctor updated successfully", user: foundUser });
    } catch (error) {
        console.error("Error updating doctor:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};


exports.deleteDoctor = async (req, res) => {
    const { id: user_id } = req.params;

    try {
        const foundUser = await user.findOne({
            where: { user_id },
            include: [{ model: doctor, as: 'doctor' }],
        });

        if (!foundUser || !foundUser.doctor) {
            return res.status(404).json({ message: "Doctor not found" });
        }

        await foundUser.doctor.destroy();

        await foundUser.destroy();

        res.status(200).json({ message: "Doctor deleted successfully" });
    } catch (error) {
        console.error("Error deleting doctor:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};


exports.getAllDoctors = async (req, res) => {
    try {
        const doctors = await user.findAll({
            include: [{ model: doctor, as: 'doctor' }],
            where: { permission: 'teacher' }, 
        });

        res.status(200).json(doctors);
    } catch (error) {
        console.error("Error fetching doctors:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exports.getStudentById = async (req, res) => {
    const { id: user_id } = req.params;

    try {
        const foundUser = await user.findOne({
            where: { user_id },
            include: [{ model: student, as: 'student' }],
        });

        if (!foundUser || !foundUser.student) {
            return res.status(404).json({ message: "Student not found" });
        }

        res.status(200).json(foundUser);
    } catch (error) {
        console.error("Error fetching student:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.updateStudent = async (req, res) => {
    const { id: user_id } = req.params;
    const { user_name, date_of_birth, email, student: studentData } = req.body;

    try {
        const foundUser = await user.findOne({
            where: { user_id },
            include: [{ model: student, as: 'student' }],
        });

        if (!foundUser || !foundUser.student) {
            return res.status(404).json({ message: "Student not found" });
        }

        // تحديث بيانات المستخدم
        await foundUser.update({
            user_name,
            date_of_birth,
            email,
        });

        // تحديث بيانات الطالب
        if (studentData) {
            await foundUser.student.update({
                student_name: studentData.student_name,
                student_section: studentData.student_section,
                enrollment_year: studentData.enrollment_year,
                student_level: studentData.student_level,
                student_system: studentData.student_system,
                profile_picture: studentData.profile_picture,
                study_plan_id: studentData.study_plan_id,
            });
        }

        res.status(200).json({ message: "Student updated successfully", user: foundUser });
    } catch (error) {
        console.error("Error updating student:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.deleteStudent = async (req, res) => {
    const { id: user_id } = req.params;

    try {
        const foundUser = await user.findOne({
            where: { user_id },
            include: [{ model: student, as: 'student' }],
        });

        if (!foundUser || !foundUser.student) {
            return res.status(404).json({ message: "Student not found" });
        }

        // حذف بيانات الطالب
        await foundUser.student.destroy();

        // حذف المستخدم
        await foundUser.destroy();

        res.status(200).json({ message: "Student deleted successfully" });
    } catch (error) {
        console.error("Error deleting student:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.getAllStudents = async (req, res) => {
    try {
        const students = await user.findAll({
            include: [{ model: student, as: 'student' }],
            where: { permission: 'student' }, 
        });

        res.status(200).json(students);
    } catch (error) {
        console.error("Error fetching students:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};








