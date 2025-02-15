//  routes/bookRoute.js
const express = require('express');
const router = express.Router();
const multer = require("multer");
const CRUD = require('../controllers/controllPanle');
const { verifyToken } = require('../middleware/authMiddleware');
const upload = multer({dest: path.join(__dirname,'..', "../storage/temp/"),});
router.use(verifyToken);

router.post('/upload-from-excel',upload.single("file"),  CRUD.uploadExcel);



module.exports = router;