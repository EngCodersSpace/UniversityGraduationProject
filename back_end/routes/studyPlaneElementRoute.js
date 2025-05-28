const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/studyPlanElementController');
const vali= require('../validations/studyPlanElementValidation');
const { verifyToken } = require('../middleware/authMiddleware');
const {checkPermission} = require('../middleware/roleMiddleware');

router.use(verifyToken);

router.post('/study-plan-element',checkPermission('study_plan_elments', 'write'),vali.studyPlanElementValidation,CRUD.createStudyPlanElement);
router.get('/get-study-plan-element', CRUD.getStudyPlanElement);
router.get('/get-All-study-plan-element', CRUD.getAllStudyPlanElement);
router.put('/update-study-plan-element',checkPermission('study_plan_elments', 'write'), CRUD.updateStudyPlanElement);
router.delete('/delete-study-plan-element',checkPermission('study_plan_elments', 'write'), CRUD.deleteStudyPlanElement);

router.get('/study-plan-element-Panel', CRUD.getStudyPlanElementPanel);

module.exports = router;
