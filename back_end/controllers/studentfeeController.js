// controllers/studentFeeController.js
const { student_fee, student } = require('../models');
const { validationResult } = require('express-validator');


exports.createStudentFee = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
        const {} = req.body;
        const fee = await student_fee.create(req.body,{
            include:[
                {model:student, as:'student'}
            ]
        });


        res.status(201).json({
                message :'Make fee successfully',
                Fee     :   fee
            });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// For Student see
exports.getAllFees = async (req, res) => {
    try {
        const studentId = req.user.user_id;
        const fees = await student_fee.findAll({
            where:{student_id:studentId},
            include: {
                model: student
            },
        });
        res.status(200).json({
            message:'These all your Fees',
            Fees:fees
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

//  For Doctor see   All fees of specific Student during student_id
exports.getAllFeesDoc = async (req, res) => {
    const {studentId} = req.body;
    if (!studentId) {
        return res.status(400).json({ message: 'Student ID is required' });
    }
    try {
        const FEES = await student_fee.findAll({
            where:{student_id:studentId},
            include: {
                model: student
            },
        });
        if (!FEES.length) {
            return res.status(404).json({ message: 'No Fee found for this Student' });
        }
        res.status(200).json({
            message:'These all Fees for Student',
            Fees:FEES
        });
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