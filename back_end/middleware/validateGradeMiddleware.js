const Joi = require('joi');

exports.validateGrade = (req, res, next) => {
    const schema = Joi.object({
        score: Joi.number().min(0).max(100).required(),
        studentId: Joi.string().required()
    });

    const { error } = schema.validate(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    next();
};

// module.exports = validateGrade;
