
const { role, permission } = require('../models'); 


const checkRole = (requiredRoles) => (req, res, next) => {
    if (!req.user || !req.user.permission) {
        return res.status(403).json({ error: 'Permission denied' });
    }

    const roles = Array.isArray(requiredRoles) ? requiredRoles : [requiredRoles];

    if (!roles.includes(req.user.permission)) {
        return res.status(403).json({ error: 'You do not have the required permissions' });
    }

    next();
};

const checkPermission = (target, action) => async (req, res, next) => {
    try {

        if (!req.user || !req.user.permission) {
            return res.status(401).json({ error: 'Permission denied: User not authenticated' });
        }


        const userRole = await role.findOne({
            where: { id: req.user.permission }, 
            include: {
                model: permission,
                through: { attributes: [] } 
            }
        });
  
        if (!userRole) {
            return res.status(403).json({ error: 'Permission denied: Role not found' });
        }


        const userPermissions = userRole.permissions
        .map(permission => permission.dataValues)  
        .filter(p => p.target === target)         
        .map(p => p.action); 


        if (!userPermissions.includes(action)) {
            return res.status(403).json({ error: `Permission denied: Missing [${target}, ${action}] permission` });
        }

        next();
    } catch (error) {
        console.error('Permission check failed:', error);
        res.status(500).json({ error: 'Internal server error' , error:error.message});
    }
};


module.exports={checkRole ,checkPermission};
