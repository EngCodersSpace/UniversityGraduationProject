const express = require('express');
const router = express.Router();
const CRUD= require('../controllers/subjectController')
const vali=require('../validations/subjectValidation')

router.post('/create-subject',vali.validateSubjectCreate,CRUD.createSubject);
router.get('/get-subject-id',CRUD.getSubjectById);
router.get('/get-all-subject',CRUD.getAllSubject);
router.put('/update-subject',vali.validateSubjectUpdate,CRUD.updateSubject);
router.delete('/delete-subject',CRUD.deleteSubject);


module.exports = router;
