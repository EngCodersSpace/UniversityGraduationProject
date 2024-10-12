//  server.js
const express = require('express');
const dotenv = require("dotenv");
const { user } = require('./models'); 
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const SECRET_KEY = process.env.SECRET_KEY ;

dotenv.config({ path: './.env' });
const app = express();
app.use(express.json());

function generateToken(params = {}) {
    return jwt.sign(params,SECRET_KEY , {
        expiresIn: 78300, // مدة انتهاء الصلاحية (يمكن تعديلها حسب الحاجة)
    });
}

async function login(req, res) {
        const { id, password, islogged } = req.body; 

        try {
            const userRecord = await user.findOne({ where: { user_id: id } });

            if (!userRecord) {
                return res.status(400).send({
                    status: 0,
                    message: 'User ID or password is incorrect!',
                    user: {}
                });
            }

            if (!bcrypt.compareSync(password, userRecord.password)) {
                return res.status(400).send({
                    status: 0,
                    message: 'User ID or password is incorrect!',
                    user: {}
                });
            }

            const user_id = userRecord.user_id; 

            await user.update({
                islogged
            }, {
                where: {
                    id: user_id
                }
            });

            userRecord.password = undefined; 

            const token = generateToken({ user_id: userRecord.user_id });

            return res.status(200).send({
                status: 1,
                message: "User logged in successfully!",
                user: userRecord,
                token
            });

        } catch (error) {
            return res.status(500).send({
                status: 0,
                message: 'Server error',
                error: error.message
            });
        }
}

app.post('/login', login);

const PORT = process.env.PORT ;
// Start server
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});


















// const authRoutes = require('./routes/authRoute')
// app.use(authRoutes);

// const easyRoute = require('./routes/esayRoute')
// app.use('/api', easyRoute);
// const userRoutes = require('./routes/userRoute');


