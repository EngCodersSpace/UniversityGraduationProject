// studentFeeRoute.js
const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/studentfeeController');
// const vali = require('../validations/studentFeeValidation');
const { verifyToken  } = require('../middleware/authMiddleware');

// router.post('/create-student-fee', vali.createStudentFee,   CRUD.createStudentFee);

router.get('/get-all-fee', verifyToken, CRUD.getAllFees);

router.get('/get-allFee-controll', CRUD.getAllFeesDoc);

// router.put('/update-fee',vali.updateFee, CRUD.updateFee);
// router.delete('/delete-fee',     CRUD.deleteFee);
 
module.exports = router;