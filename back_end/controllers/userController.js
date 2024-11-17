// controllers/userController.js
const bcrypt = require('bcrypt');
const { user } = require('../models'); 

// إنشاء مستخدم جديد (Create User)
exports.createUser = async (req, res) => {
    const { user_id,user_name, email, password, date_of_birth, permission } = req.body;
    try {
        const newUser = await user.create({
            user_id,
            user_name,
            email,
            password, 
            date_of_birth,
            permission,
        });
        res.status(201).json({ message: 'User created successfully', user: newUser });
    } catch (error) {
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

// قراءة جميع المستخدمين (Read All Users)
exports.getAllUsers = async (req, res) => {
    try {
        const users = await user.findAll();
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

// قراءة مستخدم معين بالـ ID (Read User by ID)
exports.getUserById = async (req, res) => {
    const { id } = req.params;
    try {
        const foundUser = await user.findByPk(id);
        if (!foundUser) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.status(200).json(foundUser);
    } catch (error) {
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

// تحديث مستخدم (Update User)
exports.updateUser = async (req, res) => {
    const { id } = req.params;
    const { user_name, email, password, date_of_birth, permission } = req.body;
    try {
        const foundUser = await user.findByPk(id);
        if (!foundUser) {
            return res.status(404).json({ message: 'User not found' });
        }

        foundUser.user_name = user_name || foundUser.user_name;
        foundUser.email = email || foundUser.email;
        if (password) {
            foundUser.password = bcrypt.hashSync(password, 10); // تشفير كلمة المرور الجديدة
        }
        foundUser.date_of_birth = date_of_birth || foundUser.date_of_birth;
        foundUser.permission = permission || foundUser.permission;

        await foundUser.save();

        res.status(200).json({ message: 'User updated successfully', user: foundUser });
    } catch (error) {
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

// حذف مستخدم (Delete User)
exports.deleteUser = async (req, res) => {
    const { id } = req.params;
    try {
        const foundUser = await user.findByPk(id);
        if (!foundUser) {
            return res.status(404).json({ message: 'User not found' });
        }

        await foundUser.destroy();
        res.status(200).json({ message: 'User deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};










