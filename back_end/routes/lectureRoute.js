const express = require('express');
const router = express.Router();
const { 
    createLecture,
    getLectures,
    getLectureById, 
    updateLecture, 
    deleteLecture,
    getLecturesBySection,
    getLecturesByLevel,
    getLecturesByDoctor,
    getLectureBySubject,
    getSpecificLecture,
    getLecturesGroupedByCriteria
 } = require('../controllers/lectureController');
const vali=require('../validations/lecturevalidation')

router.post('/create-lecture', vali.createLectureValidator ,createLecture);

router.get('/get-all-lecture', getLectures);

router.get('/get-lecture/:id', getLectureById);

router.put('/update-lecture/:id',vali.updateLectureValidator, updateLecture);

router.delete('/delete-lecture/:id', deleteLecture);

router.get('/lectures/section/:sectionId', getLecturesBySection);
router.get('/lectures/level/:levelId', getLecturesByLevel);
router.get('/lectures/doctor/:doctorId', getLecturesByDoctor);
router.get('/lectures/subject/:subjectId', getLectureBySubject);
router.get('/lectures/Specific', getSpecificLecture);
// router.get('/lectures/lectures/:section_id?/:level_id?', getLecturesGroupedByCriteria);
router.get('/lectures/lectures/:section_id?/:level_id?/:year?/:term?/:day?', getLecturesGroupedByCriteria);


module.exports = router;
