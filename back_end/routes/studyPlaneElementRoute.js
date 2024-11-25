const express = require('express');
const router = express.Router();
const s_p_c = require('../controllers/studyPlanElementController');
const vali= require('../validations/studyPlanElementValidation');


router.post('/study-plan-element',vali.studyPlanElementValidation,s_p_c.createStudyPlanElement);
router.get('/study-plan-element/:id', s_p_c.getStudyPlanElement);
router.put('/study-plan-element/:id', s_p_c.updateStudyPlanElement);
router.delete('/study-plan-element/:id', s_p_c.deleteStudyPlanElement);

module.exports = router;
