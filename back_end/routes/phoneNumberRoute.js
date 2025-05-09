const express = require('express');
const router = express.Router();
const CRUD= require('../controllers/phoneNumberController');
const { verifyToken } = require('../middleware/authMiddleware');
const {checkPermission} = require('../middleware/roleMiddleware');

router.use(verifyToken);

router.post('/create-phone-numbers',checkPermission('phone_numbers', 'write'), CRUD.createPhoneNumber);
router.put('/update-phone-numbers',checkPermission('phone_numbers', 'write'), CRUD.updatePhoneNumber);
router.delete('/delete-phone-numbers/:user_id/:phone_number',checkPermission('phone_numbers', 'write'), CRUD.deletePhoneNumber);
router.get('/get-phone-numbers/:user_id', CRUD.getPhoneNumbersForUser);

module.exports = router;