// utils/multerConfig.js
const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Utility function to create folders if they don't exist  (duplicate)
const createFolderIfNotExists = async (folderPath) => {
    try {
        await fs.promises.access(folderPath);
    } catch {
        await fs.promises.mkdir(folderPath, { recursive: true });
    }
};

// List of valid categories
const validCategories = ["Lecture", "ExamForm", "Reference"];

// Configure multer storage
const storage = multer.diskStorage({
    destination: async (req, file, cb) => {
        console.log('Processing file:', file); 

        const uploadFolderBase = path.join(__dirname, '../storage/library');
        const { category } = req.query;

        if (!category || !validCategories.includes(category)) {
            return cb(new Error("Invalid or missing category."), false);
        }

        const categoryFolder = path.join(uploadFolderBase, category);

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
}).fields([{ name: 'file', maxCount: 1 }]);

module.exports = {
    uploadFields: upload, 
};