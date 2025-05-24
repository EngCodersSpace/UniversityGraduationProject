const { user,role, permission } = require("../models");

const checkRole = (requiredRoles) => (req, res, next) => {
  if (!req.user || !req.user.permission) {
    return res.status(403).json({ error: "Permission denied" });
  }

  const roles = Array.isArray(requiredRoles) ? requiredRoles : [requiredRoles];

  if (!roles.includes(req.user.permission)) {
    return res
      .status(403)
      .json({ error: "You do not have the required permissions" });
  }

  next();
};

const checkPermission = (target, action) => async (req, res, next) => {
  try { 
    //at login permission=roleName (Dean , Controller,..etc)
    if (!req.user || !req.user.permission) {
      return res.status(401).json({ error: "Permission denied: User not authenticated" });
    }
    const userRole = await role.findOne({
      where: { id: req.user.user_id },
      include:[ 
        {
        model: permission,
        through: { attributes: [] },
        },
     ],
    });
    if (!userRole) {
      return res.status(403).json({ error: "Permission denied: Role not found " });
    }
    const userPermissions = userRole.permissions.filter((p) => p.target === target).map((p) => p.action);
    if (!userPermissions.includes(action)) {
      return res.status(403).json({error: `Permission denied: Missing [${target}, ${action}] permission`});
    }
    next();
  } catch (error) {
    console.error("Permission check failed:", error);
    res.status(500).json({ error: "Internal server error", error: error.message });
  }
};

//check if user logged-in is = req.query.studentId   (Grades)
const checkStudentAccess = (req, res, next) => {
  const { studentID } = req.query;

  if (!req.user || !req.user.user_id) {
    return res.status(401).json({ error: 'Access denied: Not authenticated' });
  }

  if (parseInt(studentID) !== req.user.user_id) {
    return res.status(403).json({ error: 'Access denied: You are not allowed to access here' });
  }

  next();
};

//check if logged-in user is realy doctor     (general)
const checkStudentsAccess = async (req, res, next) => {
  try {
    if (!req.user || !req.user.user_id) {
      return res.status(401).json({ error: 'Access denied: Not authenticated' });
    }

    const studentId = req.user.user_id;

    const userData = await user.findOne({
      where: { user_id: studentId },
      attributes: ['roleId'],
      include: {
        model: role,
        include: {
          model: permission,
          through: { attributes: [] },
        },
      },
    });

    if (!userData || !userData.role || userData.role.roleName === 'Dean' || userData.role.roleName === 'Controller') {
      return res.status(403).json({ error: 'Access denied: Only Students can access this route' });
    }

    next();
  } catch (error) {
    console.error('Students access check failed:', error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
};


//check if logged-in user is realy doctor   (genral)
const checkDoctorAccess = async (req, res, next) => {
  try {
    if (!req.user || !req.user.user_id) {
      return res.status(401).json({ error: 'Access denied: Not authenticated' });
    }

    const doctorId = req.user.user_id;

    const userData = await user.findOne({
      where: { user_id: doctorId },
      attributes: ['roleId'],
      include: {
        model: role,
        include: {
          model: permission,
          through: { attributes: [] },
        },
      },
    });

    if (
      !userData ||
      !userData.role ||
      userData.role.roleName === 'Student' ||
      userData.role.roleName === 'Student Representative'
    ) {
      return res.status(403).json({ error: 'Access denied: Only doctors can access this route' });
    }

    next();
  } catch (error) {
    console.error('Doctor access check failed:', error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
};

// check if user logged in .....== but i realy use this inside route (general)
const checkUserAccess = (req, res, next) => {
  if (!req.user || !req.user.user_id) {
    return res.status(401).json({ error: 'Access denied: Not authenticated' });
  }

  // No roleName check — just ensures user is logged in
  next();
};



module.exports = { checkRole, checkPermission,checkStudentAccess ,checkDoctorAccess,checkUserAccess , checkStudentsAccess};
