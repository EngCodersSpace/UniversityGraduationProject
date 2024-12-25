const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/lectureController');
const vali=require('../validations/lecturevalidation')
const { verifyToken } = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');

router.use(verifyToken);

router.post('/create-lecture', checkRole(['student_affairs', 'teacher']), vali.createLectureValidator ,CRUD.createLecture);
router.put('/update-lecture/:id', checkRole(['student_affairs', 'teacher']),vali.updateLectureValidator, CRUD.updateLecture);
router.post('/replaceOne-lecture', checkRole(['student_affairs', 'teacher']),CRUD.replaceOne);


router.delete('/delete-lecture/:id', checkRole('teacher'), CRUD.deleteLecture);

router.get('/get-all-lecture', CRUD.getLectures);
router.get('/lectures/grouped', CRUD.getLecturesGroupedByCriteria);
router.get('/lecture/year', CRUD.getLectureYear);
router.get('/lecture/doctor', verifyToken , CRUD.getDoctorLectures );

module.exports = router;