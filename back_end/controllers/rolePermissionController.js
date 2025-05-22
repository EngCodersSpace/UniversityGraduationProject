
const { role, permission,  role_permission } = require('../models');

// Create a new role
exports.createRole = async (req, res) => {
  try {
    const newrole = await role.create( {roleName:req.body.roleName , user_type:req.body.user_type} );
    res.status(201).json({
        message:'Create role successfully',
        data: newrole
    });
  } catch (error) {
    res.status(500).json({ message: 'Error creating role', error:error.message });
  }
};

// Get all roles
exports.getRoles = async (req, res) => {
  try {
    const roles = await role.findAll(
      {
        include: [ 
        { model: permission, 
          through:{ attributes: [] },
          }
        ],
      }
    );
    res.json({
        message:'get all roles successfully',
        data: roles
    });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching roles', error:error.message});
  }
};

// Delete a role
exports.deleteRole = async (req, res) => {
  try {
    await role.destroy({ where: { id: req.query.id} });
    res.json({ message: 'Role deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting role', error:error.message });
  }
};



// Create a new permission
exports.createPermission = async (req, res) => {
    try {
      const newPermission = await permission.create({ target:req.body.target , action :req.body.action});
      res.status(201).json({
        message:'Create permission successfully',
        data: newPermission
      });
    } catch (error) {
      res.status(500).json({ message: 'Error creating permission', error:error.message });
    }
};
  
// Get all permissions
exports.getPermissions = async (req, res) => {
  try {
    const permissions = await permission.findAll();
    res.json({
      message:'get all permissions successfully',
      data: permissions
    });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching permissions', error:error.message});
  }
};

// Delete a permission
exports.deletePermission = async (req, res) => {
  try {
    await permission.destroy({ where: { id : req.query.id} });
    res.json({ message: 'Permission deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting permission', error:error.message});
  }
};



// Assign a permission to a role
exports.assignPermissionToRole = async (req, res) => {
    try {
      await role_permission.create({ roleId :req.query.roleId, permissionId:req.query.permissionId });
      res.status(201).json({ message: 'Permission assigned to role successfully', data:role_permission });
    } catch (error) {
      res.status(500).json({ message: 'Error assigning permission', error:error.messag});
    }
};
  
// Get all permissions for a role
exports.getRolePermissions = async (req, res) => {
    try {
        const permissions = await role_permission.findAll({
          where: { roleId:req.query.roleId },
        });
        res.json({
          message:`get all permissions of role:${req.query.roleId} successfully`,
          data: permissions
        });
    } catch (error) {
        res.status(500).json({ message: 'Error fetching role permissions', error });
    }
};
  
// Remove a permission from a role
exports.removePermissionFromRole = async (req, res) => {
    try {
      await role_permission.destroy({ where: { roleId :req.query.roleId, permissionId:req.query.permissionId } });
      res.json({ message: 'Permission removed from role' });
    } catch (error) {
      res.status(500).json({ message: 'Error removing permission',  error:error.messag });
    }
};


// for Admin panel 
exports.getRolesPanel = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = ["id","roleName","user_type"];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      roleName,
      user_type,
      page = 1,
      limit = 10,
      orderBy = "id",
      sort = "ASC",
      search,
    } = req.query;

    const pageNumber = parseInt(page, 10);
    let limitNumber = parseInt(limit, 10);
    const LOWER_LIMIT = 10;
    const UPPER_LIMIT = 250;
    if (isNaN(limitNumber) || limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
    if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;
    const offset = (pageNumber - 1) * limitNumber;
    const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy) ? orderBy : "id";
    const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase()) ? sort.toUpperCase() : "ASC";

    const { count, rows: Roles } = await role.findAndCountAll({
      where: {
        ...(roleName && {
          roleName: roleName  
        }),
        ...(user_type && {
          user_type: user_type  
        }),
        ...(search &&{
          [Op.or]: [
            { roleName: { [Op.like]: `%${search}%` } },
          ],
        }),
      },
      
      include: [ 
        { model: permission, 
          through:{ attributes: [] },
          required: true}
        ],
      distinct: true,
      limit: limitNumber,
      offset: offset,
      order: [[validOrderBy, validSort]],
    });

    if (!Roles.length) {
      return res.status(404).json({ message: "No Roles found for the specified criteria" });
    }

    res.status(200).json({
      message: "Role retrieved successfully",
      data: Roles,
      pagination: {
        totalRoles: count,
        totalPages: Math.ceil(count / limitNumber),
        currentPage: pageNumber,
        perPage: limitNumber,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error retrieving Roles", error: error.message });
  }
};

// we not use it until now
exports.getPermissionsPanel = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = ["id","target","action"];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      target,
      action,
      page = 1,
      limit = 10,
      orderBy = "id",
      sort = "ASC",
      search,
    } = req.query;

    const pageNumber = parseInt(page, 10);
    let limitNumber = parseInt(limit, 10);
    const LOWER_LIMIT = 10;
    const UPPER_LIMIT = 250;
    if (isNaN(limitNumber) || limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
    if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;
    const offset = (pageNumber - 1) * limitNumber;
    const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy) ? orderBy : "id";
    const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase()) ? sort.toUpperCase() : "ASC";

    const { count, rows: Permissions } = await permission.findAndCountAll({
      where: {
        ...(target && {
          target: target  
        }),
        ...(action && {
          action: action  
        }),
       
        ...(search &&{
          [Op.or]: [
            { target: { [Op.like]: `%${search}%` } },
            { action: { [Op.like]: `%${search}%` } },
          ],
        }),
      },
      
      // include: [ { model: user, as: "user",required: true}],
      distinct: true,
      limit: limitNumber,
      offset: offset,
      order: [[validOrderBy, validSort]],
    });

    if (!Permissions.length) {
      return res.status(404).json({ message: "No Permissions found for the specified criteria" });
    }

    res.status(200).json({
      message: "Permissions retrieved successfully",
      data: Permissions,
      pagination: {
        totalPermissions: count,
        totalPages: Math.ceil(count / limitNumber),
        currentPage: pageNumber,
        perPage: limitNumber,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error retrieving Roles", error: error.message });
  }
};

//  we not use it until now
exports.getRolesPermissionsPanel = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = ["id","roleId","permissionId"];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      roleId,
      permissionId,
      page = 1,
      limit = 10,
      orderBy = "id",
      sort = "ASC",
      search,
    } = req.query;

    const pageNumber = parseInt(page, 10);
    let limitNumber = parseInt(limit, 10);
    const LOWER_LIMIT = 10;
    const UPPER_LIMIT = 250;
    if (isNaN(limitNumber) || limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
    if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;
    const offset = (pageNumber - 1) * limitNumber;
    const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy) ? orderBy : "id";
    const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase()) ? sort.toUpperCase() : "ASC";

    const { count, rows: RolesPermissions } = await role_permission.findAndCountAll({
      where: {
        ...(roleId && {
          roleId: roleId  
        }),
        ...(permissionId && {
          permissionId: permissionId  
        }),
       
        // ...(search &&{
        //   [Op.or]: [
        //     { roleId: { [Op.like]: `%${search}%` } },
        //     { permissionId: { [Op.like]: `%${search}%` } },
        //   ],
        // }),
      },
      include: [{model: role, as: "role",required: true},{model: permision, as: "permision",required: true} ],
      distinct: true,
      limit: limitNumber,
      offset: offset,
      order: [[validOrderBy, validSort]],
    });

    if (!RolesPermissions.length) {
      return res.status(404).json({ message: "No Permissions found for the specified criteria" });
    }

    res.status(200).json({
      message: "Roles-Permissions retrieved successfully",
      data: RolesPermissions,
      pagination: {
        total: count,
        totalPages: Math.ceil(count / limitNumber),
        currentPage: pageNumber,
        perPage: limitNumber,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error retrieving RolesPermissions", error: error.message });
  }
};
