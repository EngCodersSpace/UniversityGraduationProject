const { user } = require('../models'); 

exports.attachStudentDetails = async (req, res, next) => {
    try {
        const userId = req.user.user_id; 

        const studentDetails = await user.findOne({
            where: { user_id: userId },
            attributes: ['user_id', 'user_section_id'],  
        });

        if (!studentDetails) {
            return res.status(404).json({ message: "Student not found" });
        }

        req.studentDetails = studentDetails; 
        next();
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error retrieving student details", error: error.message });
    }
};
