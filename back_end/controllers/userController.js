// controllers/userController.js
// const bcrypt = require('bcrypt');
const { user, doctor , student ,study_plan,level,section} = require('../models'); 


exports.getUserById = async (req, res) => {
    const { id } = req.params;
    try {
        const foundUser = await user.findOne({
            where:{user_id:id},
            include: [
                {model: student, as : 'student'},
                {model: doctor , as : 'doctor' }
            ],
        });
        if (!foundUser) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.status(200).json(foundUser);
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exports.getDoctorById = async (req, res) => {
    const { id } = req.params;

    try {
        const Doctor = await doctor.findOne({
            where: { doctor_id: id }, 
            include: [
                {
                    model: user,
                    as: 'user' 
                },
            ],
        });

        if (!Doctor) {
            return res.status(404).json({ message: 'Doctor not found' });
        }

        res.status(200).json({
            message: 'Doctor found',
            data: Doctor,
        });
    } catch (error) {
        console.error('Error fetching doctor by ID:', error.message);
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

exports.updateDoctor = async (req, res) => {
    const {  id: user_id  } = req.params;
    const { user_name, date_of_birth,collegeName, email,profile_picture, doctor: doctorData } = req.body;

    try {
        const foundUser = await user.findOne({
            where: { user_id },
            include: [{model: doctor,as: 'doctor',}],
            attributes: { exclude: ['resetToken', 'resetTokenExpiry', 'updatedAt'] }, 
        });
        

        if (!foundUser || !foundUser.doctor) {
            return res.status(404).json({ message: "Doctor not found" });
        }

        await foundUser.update({
            user_name,
            date_of_birth,
            collegeName,
            email,
            profile_picture,
        });

        if (doctorData) {
            await foundUser.doctor.update({
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
            include: [{ 
                model: doctor, 
                as: 'doctor'
            }],
            where: { permission: 'teacher' }, 
        });

        const doctorsData = doctors.map(u => u.doctor?.getFullData() || {});
        res.status(200).json(doctorsData);
    } catch (error) {
        console.error("Error fetching doctors:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exports.getStudentById = async (req, res) => {
    const { id: user_id } = req.params;

    try {
        const foundStudent = await student.findOne({
            where: { student_id:user_id },
            include: [{ model: user, as: 'user' }],
        });

        if (!foundStudent || !foundStudent.user) {
            return res.status(404).json({ message: "Student not found" });
        }

        res.status(200).json(foundStudent.getFullData());
    } catch (error) {
        console.error("Error fetching student:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.updateStudent = async (req, res) => {
    const { id: user_id } = req.params;
    const { user_name, date_of_birth,collegeName, email, profile_picture, student: studentData } = req.body;

    try {
        const foundUser = await user.findOne({
            where: { user_id },
            include: [{ model: student, as: 'student' }],
        });

        if (!foundUser || !foundUser.student) {
            return res.status(404).json({ message: "Student not found" });
        }

        const [sectionFound, levelFound, study_planFound] = await Promise.all([
            section.findOne({ where: { section_name: studentData.student_section_id } }),
            level.findOne({ where: { level_name: studentData.student_level_id } }),
            study_plan.findOne({ where: { study_plan_name: studentData.study_plan_id } })
        ]);

        if (!sectionFound) {
            return res.status(400).json({ message: `Section '${studentData.student_section_id}' not found` });
        }
        if (!levelFound) {
            return res.status(400).json({ message: `Level '${studentData.student_level_id}' not found` });
        }
        if (!study_planFound) {
            return res.status(400).json({ message: `Study plan '${studentData.study_plan_id}' not found` });
        }

        await foundUser.update({
            user_name,
            date_of_birth,
            collegeName,
            email,
            profile_picture,
        });

        await foundUser.student.update({
            student_section_id: sectionFound.id,
            enrollment_year: studentData.enrollment_year,
            student_level_id: levelFound.id,
            student_system: studentData.student_system,
            study_plan_id: study_planFound.study_plan_id,
        });

        const responseUser = {
            user_id: foundUser.user_id,
            user_name: foundUser.user_name,
            date_of_birth: foundUser.date_of_birth,
            collegeName:foundUser.collegeName,
            email: foundUser.email,
            profile_picture: foundUser.profile_picture,
            student_section_id: sectionFound.section_name,
            enrollment_year: foundUser.student.enrollment_year,
            student_level_id: levelFound.level_name,
            student_system: foundUser.student.student_system,
            study_plan_id: study_planFound.study_plan_name,
        };

        res.status(200).json({
            message: "Student updated successfully",
            user: responseUser,
        });
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

        await foundUser.student.destroy();
        await foundUser.destroy();

        res.status(200).json({ message: "Student deleted successfully" });
    } catch (error) {
        console.error("Error deleting student:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.getAllStudents = async (req, res) => {
    try {
        const users = await user.findAll({
            include: [{
                model: student,
                as: 'student',
            }],
            where: { permission: 'student' },
        });

        const students = users.map(u => u.student?.getFullData() || {});

        res.status(200).json(students);
    } catch (error) {
        console.error("Error fetching students:", error);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};










