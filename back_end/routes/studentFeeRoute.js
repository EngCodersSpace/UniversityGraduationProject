// studentFeeRoute.js
const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/studentfeeController');
const {checkPermission, checkUserAccess} = require('../middleware/roleMiddleware');
const { verifyToken  } = require('../middleware/authMiddleware');
router.use(verifyToken);

router.post('/create-student-fee', checkPermission('student_fees', 'write'), CRUD.createStudentFee);
router.get('/get-all-fee',checkUserAccess, CRUD.getAllFees); //only for student himself
router.get('/get-allFeeOfStudent',checkPermission('student_fees', 'student_search'), CRUD.getAllFeesOfStudent);
router.get('/get-allFeeOfStudent-orderd',checkUserAccess, CRUD.getLastPayment); 
router.get('/get-Fees-panle',checkPermission('student_fees', 'student_search'), CRUD.getStudentFeesByCriteriaPanel);

router.put('/update-fee', checkPermission('student_fees', 'write'),CRUD.updateFee);
router.delete('/delete-fee', checkPermission('student_fees', 'write'), CRUD.deleteFee);
 
module.exports = router;