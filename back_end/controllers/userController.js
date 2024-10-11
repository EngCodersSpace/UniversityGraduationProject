// controllers/userController.js
const { user } = require('../models'); 
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
dotenv.config({ path: '../.env' });

const registerUser = async (userData) => {
    const { user_name, email, permission, password, date_of_birth } = userData;

    const existingUser = await user.findOne({ where: { email } });
    if (existingUser) {
        throw new Error('User already exists');
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    return await user.create({ 
        user_name, 
        email, 
        permission, 
        password: hashedPassword, 
        date_of_birth,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    });
};


exports.registerUser = async (req, res) => {
    try {
        const newUser = await registerUser(req.body);
        return res.status(201).json({ 
            message: 'User created successfully', 
            newUser 
        });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

// login using id and password
exports.loginUser = async (userData) => {
    const { id, password } = userData;  
  
    const user = await user.findOne({ where: { id } });
    if (!user) {
        throw new Error('User not found');  
    }
  
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
        throw new Error('Invalid password');
    }
  
    const token = jwt.sign({ id: user.id, permission: user.permission }, process.env.SECRET_KEY || 'default-secret', { expiresIn: '1h' });
    return { token };
};
  
// login using email and password
// exports.loginUser = async (userData) => {
//     const { email, password } = userData;

//     const user = await user.findOne({ where: { email } });
//     if (!user) {
//         throw new Error('User not found');
//     }

//     const isMatch = await bcrypt.compare(password, user.password);
//     if (!isMatch) {
//         throw new Error('Invalid password');
//     }

//     const token = jwt.sign({ id: user.id, permission: user.permission }, process.env.SECRET_KEY || 'default-secret', { expiresIn: '1h' });
//     return { token };
// };










