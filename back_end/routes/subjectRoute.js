 
const express = require('express');
const router = express.Router();
const CRUD= require('../controllers/subjectController')


router.post('/create-subject',CRUD.createSubject);
router.get('/get-subject-id/:subject_id?',CRUD.getSubjectById);
router.get('/get-all-subject',CRUD.getAllSubject);
router.put('/update-subject/:subject_id?',CRUD.updateSubject);
router.delete('/delete-subject/:subject_id?',CRUD.deleteSubject);



module.exports = router;
