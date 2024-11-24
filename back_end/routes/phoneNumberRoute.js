const express = require('express');
const router = express.Router();
const {
  createPhoneNumber,
  updatePhoneNumber,
  deletePhoneNumber,
  getPhoneNumbersForUser,
} = require('../controllers/phoneNumberController');

// Create a phone number
router.post('/create-phone-numbers', createPhoneNumber);

// Update a phone number
router.put('/update-phone-numbers', updatePhoneNumber);

// Delete a phone number
router.delete('/delete-phone-numbers/:user_id/:phone_number', deletePhoneNumber);

// Get all phone numbers for a user
router.get('/get-phone-numbers/:user_id', getPhoneNumbersForUser);

module.exports = router;
