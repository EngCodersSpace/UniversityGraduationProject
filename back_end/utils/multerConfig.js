// utils/multerConfig.js
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadFolderBase = path.join(__dirname, '../storage/library');
        const  { category } = req.query;
        console.log('\n \n category = ', category);

        const validCategories = ["Lecture", "ExamForm", "Reference"];

        console.log('\n \n validCategories \n \n ', validCategories);

        if (!validCategories.includes(category)) {
            return cb(new Error("Invalid category specified."), false);
        }

        const categoryFolder = path.join(uploadFolderBase, category);
        if (!fs.existsSync(categoryFolder)) {
            fs.mkdirSync(categoryFolder, { recursive: true });
        }

        cb(null, categoryFolder);
    },
    filename: (req, file, cb) => {
        cb(null, `${Date.now()}_${file.originalname}`);
    }
});

const upload = multer({ storage });

module.exports = {
    uploadFields: upload.fields([
        { name: 'file', maxCount: 1 },
    ])
};