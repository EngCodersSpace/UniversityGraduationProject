
const checkRole = (requiredRoles) => (req, res, next) => {
    if (!req.user || !req.user.permission) {
        return res.status(403).json({ error: 'Permission denied or user not authenticated' });
    }

    const roles = Array.isArray(requiredRoles) ? requiredRoles : [requiredRoles];

    if (!roles.includes(req.user.permission)) {
        return res.status(403).json({ error: 'You do not have the required permissions' });
    }

    next();
};

module.exports = checkRole;

