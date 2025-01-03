

exports.validateFileName = (req, res, next) => {
    const { filename } = req.body || req.params;
    if (!filename || typeof filename !== "string") {
        return res.status(400).json({ error: "Invalid filename." });
    }
    next();
};




