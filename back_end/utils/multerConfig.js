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

// const validCategories = ["Lecture", "ExamForm", "Reference"];

// Configure multer storage
const storage = multer.diskStorage({
    destination: async (req, file, cb) => {
        console.log('Processing file:', file); 
        // const {category}= req.body;

        // if (!category || !validCategories.includes(category)) {
        //     return cb(new Error("Invalid or missing category."), false);
        // }
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
        const allowedMimetypes = [
            'image/jpeg',
            'image/png',
            'image/gif',
            'image/bmp',
            'image/webp',
            'image/svg+xml',
            'application/pdf',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'application/vnd.ms-excel',
            'application/vnd.openxmlformats-officedocument.presentationml.presentation',
            'application/vnd.ms-powerpoint',
            'video/mp4',
            'video/x-msvideo',
            'video/x-m4v',
            'audio/mpeg',
            'audio/wav',
            'audio/ogg',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'application/msword',
            'application/zip',
            'text/csv',        
        ];
    
        if (!allowedMimetypes.includes(file.mimetype)) {
            return cb(new Error('File type not allowed.'), false);
        }
        cb(null, true);
    },


}).fields([{ name: 'files', maxCount: 10 }]);

module.exports = {
    uploadFields: upload, 
};