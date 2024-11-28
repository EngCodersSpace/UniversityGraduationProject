const express = require('express');
const router = express.Router();
const { createLecture, getLectures, getLectureById, updateLecture, deleteLecture } = require('../controllers/lectureController');
const vali=require('../validations/lecturevalidation')

router.post('/create-lecture', vali.createLectureValidator ,createLecture);

router.get('/get-all-lecture', getLectures);

router.get('/get-lecture/:id', getLectureById);

router.put('/update-lecture/:id',vali.updateLectureValidator, updateLecture);

router.delete('/delete-lecture/:id', deleteLecture);

module.exports = router;
