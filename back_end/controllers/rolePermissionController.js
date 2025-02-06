

const { role, permission,  role_permission } = require('../models');

// Create a new role
exports.createRole = async (req, res) => {
  try {
    const newrole = await role.create( {roleName:req.body.roleName} );
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
    const roles = await role.findAll();
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
