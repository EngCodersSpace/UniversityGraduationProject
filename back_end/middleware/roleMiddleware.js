


const checkRole = (requiredRole) => (req, res, next) => {
    if (!req.user || !req.user.permission) {
        return res.status(403).json({ error: 'Permission denied or user not authenticated' });
    }

    if (req.user.permission !== requiredRole) {
        return res.status(403).json({ error: 'You do not have the required permissions' });
    }

    next();
};

module.exports = checkRole;










// exports.authorize = (roles = []) => {
//     return (req, res, next) => {
//         if (!roles.includes(req.user.permission)) { 
//             return res.status(403).json({ message: `Access Denied - Forbidden: Only ${roles}s can access` });
//         }
//         next();
//     };
// };













//  OR 


// JUST FOR ONE ROLE
// const checkRole = (role) => (req, res, next) => {
//     if (req.user.permission !== role) {
//         return res.status(403).json({ message: `Forbidden: Only ${role}s can access this data` });
//     }
//     next();
// };

// module.exports = checkRole;








