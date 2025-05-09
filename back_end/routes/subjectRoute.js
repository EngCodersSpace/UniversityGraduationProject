const express = require('express');
const router = express.Router();
const CRUD= require('../controllers/subjectController')
const vali=require('../validations/subjectValidation')
const { verifyToken } = require('../middleware/authMiddleware');
const {checkPermission} = require('../middleware/roleMiddleware');

router.use(verifyToken);

router.post('/create-subject',checkPermission('subjects', 'write'),vali.validateSubjectCreate,CRUD.createSubject);
router.get('/get-subject-id',CRUD.getSubjectById);
router.get('/get-all-subject',CRUD.getAllSubject);
router.get('/get-subject-by-filter',CRUD.getSubjectByfilter);
router.get('/get-subject-panle',CRUD.getSubjectsByCriteriaPanel);

router.put('/update-subject',checkPermission('subjects', 'write'),vali.validateSubjectUpdate,CRUD.updateSubject);
router.delete('/delete-subject',checkPermission('subjects', 'write'),CRUD.deleteSubject);

module.exports = router;