
const {student, student_assignment,assignment} = require("../models");


exports.getAssignmentsBySubject = async (req, res) => {
    try {
      const assignments = await assignment.findAll({
        where: { subject_id:req.query.subject_id },
        include: [
          {
            model: student, 
            attributes: [], 
            // through:{ attributes: [] },
            through: {
                attributes: ["status", "attachment"], 
                where: { student_id:req.user.user_id }, 
            },
          },
        ]
      });
  
      if (!assignments.length) {
        return res.status(404).json({ message: "No assignments found for this subject." });
      }
  
      res.status(200).json({ message: "Assignments retrieved successfully", data: assignments });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Error retrieving assignments", error: error.message });
    }
};
  