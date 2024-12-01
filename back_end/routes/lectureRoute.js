const express = require('express');
const router = express.Router();
const { 
    createLecture,
    getLectures,
    updateLecture, 
    deleteLecture,
    getLecturesGroupedByCriteria,
    getLectureYear
 } = require('../controllers/lectureController');
const vali=require('../validations/lecturevalidation')

router.post('/create-lecture', vali.createLectureValidator ,createLecture);
router.put('/update-lecture/:id',vali.updateLectureValidator, updateLecture);
router.delete('/delete-lecture/:id', deleteLecture);


router.get('/get-all-lecture', getLectures);
router.get('/lectures/:section_id?/:level_id?/:year?/:term?/:day?', getLecturesGroupedByCriteria);
router.get('/lecture/year', getLectureYear);


module.exports = router;
