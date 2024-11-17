// doctorcontroller.js

const { doctor, user } = require('../models');
const { doctorSchema, updateDoctorSchema } = require('../validations/doctorvalidation');



exports.getAllDoctors = async (req, res) => {

    try {
        const doctors = await doctor.findAll({
            include: [{ model: user, attributes: ['user_name', 'email'] }],
        });
        res.status(200).json(doctors);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getDoctorById = async (req, res) => {

    try {
        const singleDoctor = await doctor.findOne({
            where: { doctor_id: req.params.id },
            include: [{ model: user, attributes: ['user_name', 'email'] }],
        });

        if (!singleDoctor) return res.status(404).json({ message: 'Doctor not found' });

        res.status(200).json(singleDoctor);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.createDoctor = async (req, res) => {

    // Validate request body
    const { error, value } = doctorSchema.validate(req.body);

    if (error) {
        return res.status(400).json({
            message: 'Validation Error',
            details: error.details[0].message,
        });
    }

    const { doctor_id } = value;

    try {
        const userExists = await user.findOne({ where: { user_id: doctor_id } });

        if (!userExists) {
            return res.status(404).json({ message: 'User not found for the given doctor ID' });
        }

        const newDoctor = await doctor.create(value); // Use validated data
        res.status(201).json(newDoctor);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.updateDoctor = async (req, res) => {
    // Validate request body
    const { error, value } = updateDoctorSchema.validate(req.body);

    if (error) {
        return res.status(400).json({
            message: 'Validation Error',
            details: error.details[0].message,
        });
    }

    try {
        const doctorToUpdate = await doctor.findOne({ where: { doctor_id: req.params.id } });

        if (!doctorToUpdate) {
            return res.status(404).json({ message: 'Doctor not found' });
        }

        const updatedDoctor = await doctorToUpdate.update(value);
        res.status(200).json(updatedDoctor);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.deleteDoctor = async (req, res) => {
    try {
        const deleted = await doctor.destroy({ where: { doctor_id: req.params.id } });

        if (!deleted) return res.status(404).json({ message: 'Doctor not found' });

        res.status(204).send();
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};







