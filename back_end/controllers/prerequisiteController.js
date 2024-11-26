
// controllers/prerequisiteController.js
const { prerequisite, subject, study_plan_elment } = require('../models');

exports.createPrerequisite = async (req, res) => {
    try {
        const { subject_id, study_plan_elment_id } = req.body;
        const prereq = await prerequisite.create({ subject_id, study_plan_elment_id });
        res.status(201).json(prereq);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


exports.getAllPrerequisites = async (req, res) => {
    try {
        const prereqs = await prerequisite.findAll({
            include: [
                {
                    model: subject,
                    attributes: ['name', 'code'], // حقول المادة
                },
                {
                    model: study_plan_elment,
                    attributes: ['type', 'semester'], // حقول الخطة الدراسية
                },
            ],
        });
        res.status(200).json(prereqs);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


exports.updatePrerequisite = async (req, res) => {
    try {
        const { id } = req.params;
        const { subject_id, study_plan_elment_id } = req.body;
        const prereq = await prerequisite.update(
            { subject_id, study_plan_elment_id },
            { where: { id } }
        );
        res.status(200).json({ message: 'Prerequisite updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


exports.deletePrerequisite = async (req, res) => {
    try {
        const { id } = req.params;
        await prerequisite.destroy({ where: { id } });
        res.status(200).json({ message: 'Prerequisite deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

