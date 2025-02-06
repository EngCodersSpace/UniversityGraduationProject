// controllers/studentFeeController.js
const { student_fee, student } = require('../models');
// const { validationResult } = require('express-validator');

exports.createStudentFee = async (req, res) => {
    try {
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

// For Student see his fees
exports.getAllFees = async (req, res) => {
    try {
        const fees = await student_fee.findAll({
            where:{student_id:req.user.user_id},
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
exports.getAllFeesOfStudent = async (req, res) => {
    try {
        const FEES = await student_fee.findAll({
            where:{student_id:req.body.student_id},
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

exports.getLastPayment = async (req, res) => {
    try {
        const lastPayment = await student_fee.findOne({
            where: { student_id: req.user.user_id },
            order: [['payment_date', 'DESC']]
        });

        if (lastPayment) {
            res.status(200).json({
                message: 'This is your most recent payment.',
                lastPayment,
            });
        } else {
            res.status(404).json({
                message: 'No payment records found for this student.',
            });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};







exports.updateFee = async (req, res) => {
    try {
        await student_fee.update(req.body,
            {where:{id:req.body.id}},
        );
        const updatedFee = await student_fee.findOne({ where: { id: req.body.id } });
        res.status(200).json({ 
            message: 'Student fee updated successfully' ,
            data: updatedFee
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.deleteFee = async (req, res) => {
    try {
        await student_fee.destroy({ where: { id: req.query.id} });
        res.status(200).json({ message: 'Student fee deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};