
// services/authService.js
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const User = require('../models/user');

const login = async (username, password) => {
  const user = await User.findOne({ where: { userName: username } });
  if (!user || !(await bcrypt.compare(password, user.password))) {
    throw new Error('Invalid credentials');
  }
  return jwt.sign({ id: user.userID, role: user.permissions }, process.env.JWT_SECRET, { expiresIn: '1h' });
};

module.exports = { login };









