// controllers/studentFeeController.js
const { student_fee, student } = require('../models');

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
        console.error(error);
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
        console.error(error);
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


exports.getStudentFeesByCriteriaPanel = async (req, res) => {
    const ALLOWED_ORDER_FIELDS = ["payment_date", "total_amount", "amount_paid", "remaining_amount", "receipt_number"];
    const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];
  
    try {
      const {
        student_id,
        level_fees_id,
        term,
        total_amount,
        amount_paid,
        remaining_amount,
        receipt_number,
        page = 1,
        limit = 10,
        orderBy = "payment_date",
        sort = "ASC",
        search,
      } = req.query;
  
    //   const whereClause = {};
    //   if (student_id) whereClause.student_id = student_id;
    //   if (level_fees_id) whereClause.level_fees_id = level_fees_id;
    //   if (term) whereClause.term = term;
    //   if (total_amount) whereClause.total_amount = total_amount;
    //   if (amount_paid) whereClause.amount_paid = amount_paid;
    //   if (remaining_amount) whereClause.remaining_amount = remaining_amount;
    //   if (receipt_number) whereClause.receipt_number = receipt_number;
  
      const pageNumber = parseInt(page, 10);
      let limitNumber = parseInt(limit, 10);
  
      const LOWER_LIMIT = 10;
      const UPPER_LIMIT = 250;
      if (isNaN(limitNumber)) limitNumber = LOWER_LIMIT;
      if (limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
      if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;
  
      const offset = (pageNumber - 1) * limitNumber;
  
      const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy) ? orderBy : "payment_date";
      const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase()) ? sort.toUpperCase() : "ASC";
  
      const searchCondition = search
        ? {
            [Op.or]: [
              { receipt_number: { [Op.like]: `%${search}%` } },
              { term: { [Op.like]: `%${search}%` } },
            ],
          }
        : {};
  
      const { count, rows: studentFees } = await student_fee.findAndCountAll({
        where: {
            ...(amount_paid&&{
                amount_paid:amount_paid,
            }),
            ...(term&&{
                term:term,
            }),

            ...(search &&{
                [Op.or]: [
                    { receipt_number: { [Op.like]: `%${search}%` } },
                    { term: { [Op.like]: `%${search}%` } },
                    { amount_paid:{ [Op.like]: `%${search}%` } },
                    { amount_paid:{ [Op.like]: `%${search}%` } },
                    { amount_paid:{ [Op.like]: `%${search}%` } },
                    { amount_paid:{ [Op.like]: `%${search}%` } },
                    { amount_paid:{ [Op.like]: `%${search}%` } },
                ],
            })
        },
        include: [
          { model: student, as: "student" }, 
          { model: level, as: "level" }, 
        ],
        distinct: true,
        limit: limitNumber,
        offset: offset,
        order: [[validOrderBy, validSort]],
      });
  
      if (!studentFees.length) {
        return res.status(404).json({ message: "No student fees found for the specified criteria" });
      }
  
    //   const studentFeeList = studentFees.map((fee) => ({
    //     id: fee.id,
    //     student_id: fee.student_id,
    //     level_fees_id: fee.level_fees_id,
    //     term: fee.term,
    //     total_amount: fee.total_amount,
    //     amount_paid: fee.amount_paid,
    //     remaining_amount: fee.remaining_amount,
    //     payment_date: fee.payment_date,
    //     receipt_number: fee.receipt_number,
    //   }));
  
      res.status(200).json({
        message: "Student fees retrieved successfully",
        data: studentFees,
        pagination: {
          totalStudentFees: count,
          totalPages: Math.ceil(count / limitNumber),
          currentPage: pageNumber,
          perPage: limitNumber,
        },
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Error retrieving student fees", error: error.message });
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