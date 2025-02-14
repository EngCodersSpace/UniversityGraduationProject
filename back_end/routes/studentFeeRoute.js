// studentFeeRoute.js
const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/studentfeeController');
// const vali = require('../validations/studentFeeValidation');
const { verifyToken  } = require('../middleware/authMiddleware');
router.use(verifyToken);

router.post('/create-student-fee',  CRUD.createStudentFee);
router.get('/get-all-fee', CRUD.getAllFees);
router.get('/get-allFeeOfStudent', CRUD.getAllFeesOfStudent);
router.get('/get-allFeeOfStudent-orderd', CRUD.getLastPayment);
router.get('/get-Fees-panle', CRUD.getStudentFeesByCriteriaPanle);

router.put('/update-fee', CRUD.updateFee);
router.delete('/delete-fee',  CRUD.deleteFee);
 

module.exports = router;

