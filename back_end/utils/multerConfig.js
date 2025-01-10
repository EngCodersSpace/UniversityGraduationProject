// utils/multerConfig.js
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const createFolderIfNotExists = async (folderPath) => {
    try {
        await fs.promises.access(folderPath);
    } catch {
        await fs.promises.mkdir(folderPath, { recursive: true });
    }
};

const validCategories = ["Lecture", "ExamForm", "Reference"];

// Configure multer storage
const storage = multer.diskStorage({
    destination: async (req, file, cb) => {
        console.log('Processing file:', file); 
        const {category}= req.body;
        if (!category || !validCategories.includes(category)) {
            return cb(new Error("Invalid or missing category."), false);
        }
        // const categoryFolder =  path.resolve(__dirname, '../storage/library', category, 'books');
        const categoryFolder =  path.resolve(__dirname, '../storage' ,'temp');

        await createFolderIfNotExists(categoryFolder);
        cb(null, categoryFolder);
    },
    filename: (req, file, cb) => {
        console.log('File details:', file); 
        const originalName = file.originalname;  
        cb(null, originalName);
        // const uniqueFilename = `${Date.now()}_${file.originalname}`;
        // cb(null, uniqueFilename);
    },
});

// Configure multer upload middleware
const upload = multer({
    storage,
    fileFilter: (req, file, cb) => {
        if (!file.mimetype.includes('pdf')) {
            return cb(new Error('Only PDF files are allowed.'), false);
        }
        cb(null, true);
    },
}).fields([{ name: 'files', maxCount: 10 }]);

module.exports = {
    uploadFields: upload, 
};