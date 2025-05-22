// routes/paperFormRoutes.js

const express = require('express');
const router = express.Router();
const {checkPermission} = require('../middleware/roleMiddleware');
const { verifyToken } = require('../middleware/authMiddleware');
const CRUD = require('../controllers/paperFormController');

router.use(verifyToken);
// checkPermission('paperForm','write') ,

router.post('/form-types',  CRUD.createFormType);
router.post('/form-types/:form_type_id/steps', CRUD.addForwardStep);
router.post('/paper-forms', CRUD.submitPaperForm);
router.post('/paper-forms/:form_id/action', CRUD.takeAction);
router.get('/paper-forms/:form_id/activities', CRUD.getFormActivities);

module.exports = router;