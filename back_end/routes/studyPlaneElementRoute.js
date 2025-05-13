const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/studyPlanElementController');
const vali= require('../validations/studyPlanElementValidation');
const { verifyToken } = require('../middleware/authMiddleware');
const {checkPermission} = require('../middleware/roleMiddleware');

router.use(verifyToken);

router.post('/study-plan-element',checkPermission('study_plan_elments', 'write'),vali.studyPlanElementValidation,CRUD.createStudyPlanElement);
router.get('/study-plan-element/:id', CRUD.getStudyPlanElement);
router.put('/study-plan-element/:id',checkPermission('study_plan_elments', 'write'), CRUD.updateStudyPlanElement);
router.delete('/study-plan-element/:id',checkPermission('study_plan_elments', 'write'), CRUD.deleteStudyPlanElement);

router.get('/study-plan-element-Panel', CRUD.getStudyPlanElementPanel);

module.exports = router;
