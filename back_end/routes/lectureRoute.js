const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/lectureController');
const vali=require('../validations/lecturevalidation')
const { verifyToken } = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');

router.use(verifyToken);

router.post('/create-lecture', checkRole(['student_affairs', 'teacher','controller']), vali.createLectureValidator ,CRUD.createLecture);
router.put('/update-lecture', checkRole(['student_affairs', 'dean','controller']),vali.updateLectureValidator, CRUD.updateLecture);
router.post('/replaceOne-lecture', checkRole(['student_affairs', 'teacher','controller']),CRUD.replaceOne);
router.post('/changeLecStatus-lecture', checkRole(['representative', 'teacher','controller']),CRUD.changeLecStatus);


router.delete('/delete-lecture', checkRole('dean'), CRUD.deleteLecture);

router.get('/get-all-lecture', CRUD.getLectures);
router.get('/lectures/grouped', CRUD.getLecturesGroupedByCriteria);
router.get('/lecture/year', CRUD.getLectureYear);
router.get('/lecture/doctor', verifyToken , CRUD.getDoctorLectures );




module.exports = router;