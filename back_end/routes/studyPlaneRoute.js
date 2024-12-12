const express = require('express');
const router = express.Router();
const spc = require('../controllers/studyPlanController');
const vali= require('../validations/studyPlanValidation');

router.post('/study-plan',vali.StudyPlanValidator , spc.createStudyPlan);
router.get('/study-plan-by-id', spc.getStudyPlanById);
router.get('/study-plan', spc.getAllStudyPlan);
router.put('/study-plan-update',vali.StudyPlanValidator ,spc.updateStudyPlan);
router.delete('/study-plan-delete', spc.deleteStudyPlan);

module.exports = router;
