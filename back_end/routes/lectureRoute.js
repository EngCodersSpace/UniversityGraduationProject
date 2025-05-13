const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/lectureController');
const vali=require('../validations/lecturevalidation')
const { verifyToken } = require('../middleware/authMiddleware');
const {checkPermission} = require('../middleware/roleMiddleware');

router.use(verifyToken);

router.post('/create-lecture',checkPermission('lectures', 'write'),  vali.createLectureValidator ,CRUD.createLecture);
router.put('/update-lecture',checkPermission('lectures', 'accessOldTables'), vali.updateLectureValidator, CRUD.updateLecture);
router.post('/replaceOne-lecture',CRUD.replaceOne);
router.post('/changeLecStatus-lecture', CRUD.changeLecStatus);

router.delete('/delete-lecture', CRUD.deleteLecture);

router.get('/get-all-lecture', CRUD.getLectures);
router.get('/lectures/grouped', CRUD.getLecturesGroupedByCriteria);
router.get('/lectures/panle', CRUD.getLecturesByCriteriaPanle);

router.get('/lecture/year', CRUD.getLectureYear);
router.get('/lecture/doctor', verifyToken , CRUD.getDoctorLectures );

module.exports = router;