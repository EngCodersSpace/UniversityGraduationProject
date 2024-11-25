// controllers/studentFeeController.js
const { student_fee, student } = require('../models');

exports.createStudentFee = async (req, res) => {
    try {
        const { amount_paid, remaining_amount, payment_date, student_id } = req.body;
        const fee = await student_fee.create({ amount_paid, remaining_amount, payment_date, student_id });
        res.status(201).json(fee);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


exports.getAllFees = async (req, res) => {
    try {
        const fees = await student_fee.findAll({
            include: {
                model: student,
                attributes: ['name', 'email'], // عرض حقول الطالب
            },
        });
        res.status(200).json(fees);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


exports.updateFee = async (req, res) => {
    try {
        const { id } = req.params;
        const { amount_paid, remaining_amount, payment_date } = req.body;
        const fee = await student_fee.update(
            { amount_paid, remaining_amount, payment_date },
            { where: { id } }
        );
        res.status(200).json({ message: 'Student fee updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


exports.deleteFee = async (req, res) => {
    try {
        const { id } = req.params;
        await student_fee.destroy({ where: { id } });
        res.status(200).json({ message: 'Student fee deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};





