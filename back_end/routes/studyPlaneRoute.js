const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/studyPlanController');
const vali= require('../validations/studyPlanValidation');
const { verifyToken } = require('../middleware/authMiddleware');
const {checkPermission} = require('../middleware/roleMiddleware');

router.use(verifyToken);
router.post('/study-plan',checkPermission('study_plans', 'write'),vali.StudyPlanValidator , CRUD.createStudyPlan);
router.get('/study-plan-by-id', CRUD.getStudyPlanById);
router.get('/study-plan', CRUD.getAllStudyPlan);
router.put('/study-plan-update',checkPermission('study_plans', 'write'),vali.StudyPlanValidator ,CRUD.updateStudyPlan);
router.delete('/study-plan-delete',checkPermission('study_plans', 'write'), CRUD.deleteStudyPlan);

module.exports = router;
