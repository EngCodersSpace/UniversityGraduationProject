// doctorcontroller.js

const { doctor, user,study_plan_element } = require('../models');



exports.getDoctorById = async (req, res) => {
    const { id } = req.params;

    try {
        const foundDoctor = await doctor.findOne({
            where: { doctor_id: id },
            include: [
                {
                    model: user,
                    attributes: ['user_name', 'email', 'date_of_birth'],
                },
            ],
        });

        if (!foundDoctor) {
            return res.status(404).json({ message: 'Doctor not found' });
        }

        res.status(200).json(foundDoctor);
    } catch (error) {
        console.error('Error fetching doctor:', error.message);
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};


exports.getAllDoctors = async (req, res) => {
    try {
        const doctors = await doctor.findAll({
            include: [
                {
                    model: user,
                    attributes: ['user_name', 'email', 'date_of_birth'], // Include associated user details
                },
                {
                    model: study_plan_element, // Include associated study plan elements
                },
            ],
        });

        res.status(200).json(doctors);
    } catch (error) {
        console.error('Error fetching doctors:', error.message);
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};












