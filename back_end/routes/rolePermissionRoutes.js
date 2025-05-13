const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/rolePermissionController');
const { verifyToken } = require('../middleware/authMiddleware');
const {checkPermission} = require('../middleware/roleMiddleware');

router.use(verifyToken);

// Role Routes
router.post('/create-roles',  checkPermission('roles', 'write'), CRUD.createRole);
router.get('/get-roles',         CRUD.getRoles);
router.delete('/delete-roles',checkPermission('roles', 'write'), CRUD.deleteRole);

// Permission Routes
router.post('/create-permissions',checkPermission('permissions', 'write'), CRUD.createPermission);
router.get('/get-permissions', CRUD.getPermissions);
router.delete('/delete-permissions',checkPermission('permissions', 'write'), CRUD.deletePermission);

// Role-Permission Routes
router.post('/assign-permissions-role', CRUD.assignPermissionToRole);
router.get('/get-rolePermission', CRUD.getRolePermissions);
router.delete('/delete-permissionsFromRole', CRUD.removePermissionFromRole);

// for Admin panel
router.get('/get-roles-panel', CRUD.getRolesPanel);

module.exports = router;