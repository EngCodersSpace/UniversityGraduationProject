
const {user, phone_number} = require('../models');

exports.createPhoneNumber = async (req, res) => {
    try {
      const { user_id, phone_number: number } = req.body;
  
      // Check if the user exists
      const foundUser = await user.findOne({ where: { user_id } });
      if (!foundUser) {
        return res.status(404).json({ message: "User not found" });
      }

      const newPhoneNumber = await phone_number.create({
        user_id,
        phone_number: number,
      });
  
      res.status(201).json({
        message: "Phone number created successfully",
        phoneNumber: newPhoneNumber,
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
};

exports.updatePhoneNumber = async (req, res) => {
    try {
        const { user_id, phone_number:oldPhoneNumber, newPhoneNumber } = req.body;
        
        // Check if the user exists
        const foundUser = await user.findOne({ where: { user_id } });
        if (!foundUser) {
            return res.status(404).json({ error: 'User not found' });
        }

        // Check if the old phone number exists for the user
        const phoneRecord = await phone_number.findOne({
            where: {
                user_id: user_id,
                phone_number: oldPhoneNumber,
            },
        });
        if (!phoneRecord) {
            return res.status(404).json({ error: 'Old phone number not found' });
        }

        // Update the phone number
        phoneRecord.phone_number = newPhoneNumber;
        await phoneRecord.save();
    
        const updatedPhoneRecord = await phone_number.findOne({
            where: {
                user_id: user_id,
                phone_number: newPhoneNumber,
            },
        });
        // Send a success response
        return res.status(200).json({ message: 'Phone number updated successfully', phone: updatedPhoneRecord  });
    } catch (error) {
        // Handle errors
        console.error(error);
        res.status(500).json({ error: error.message });
    }
};

exports.getPhoneNumbersForUser = async (req, res) => {
    try {
      const { user_id } = req.params;
  
      const foundUser = await user.findByPk(user_id);
      if (!foundUser) {
        return res.status(404).json({ message: "User not found" });
      }
  
      // Get all phone numbers for the user
      const phoneNumbers = await phone_number.findAll({
        where: { user_id },
      });
  
      res.status(200).json(phoneNumbers);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
};

exports.deletePhoneNumber = async (req, res) => {
  try {
    const { user_id, phone_number: number } = req.params;

    // Ensure the phone number exists for the given user
    const phoneNumber = await phone_number.findOne({
      where: { user_id, phone_number: number },
    });

    if (!phoneNumber) {
      return res
        .status(404)
        .json({ message: "Phone number not found for the specified user" });
    }

    // Delete the phone number
    await phoneNumber.destroy();

    res.status(200).json({ message: "Phone number deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
