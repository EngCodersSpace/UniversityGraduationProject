const express = require('express');
const router = express.Router();
const { 
    createLecture,
    getLectures,
    updateLecture, 
    deleteLecture,
    getLecturesGroupedByCriteria,
    getLectureYear,
    getDoctorLectures
 } = require('../controllers/lectureController');
const vali=require('../validations/lecturevalidation')
const { verifyToken } = require('../middleware/authMiddleware');


router.post('/create-lecture', vali.createLectureValidator ,createLecture);
router.put('/update-lecture/:id',vali.updateLectureValidator, updateLecture);
router.delete('/delete-lecture/:id', deleteLecture);


router.get('/get-all-lecture', getLectures);
router.get('/lectures/grouped', getLecturesGroupedByCriteria);
router.get('/lecture/year', getLectureYear);
router.get('/lecture/doctor', verifyToken , getDoctorLectures );


module.exports = router;
