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

const storage = multer.diskStorage({
  destination: async (req, file, cb) => {
    try {
      const categoryFolder = path.resolve(__dirname, '../storage', 'temp');
      await createFolderIfNotExists(categoryFolder);
      cb(null, categoryFolder);
    } catch (error) {
      cb(error);
    }
  },
  filename: (req, file, cb) => {
    try {
      cb(null, file.originalname);
    } catch (error) {
      cb(error);
    }
  },
});

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
        'image/tiff',
        'image/x-icon',
      
        'application/pdf',
      
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'application/msword',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'application/vnd.ms-excel',
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
        'application/vnd.ms-powerpoint',
      
        'video/mp4',
        'video/x-msvideo',
        'video/x-m4v',
        'video/mpeg',
        'video/quicktime',
        'video/x-ms-wmv',
        'video/ogg',
        'video/webm',
      
        'audio/mpeg',
        'audio/wav',
        'audio/ogg',
      
        'application/zip',
        'application/x-rar-compressed',
      
        'text/csv',
      
        'application/javascript', 
        'text/x-python',          
        'text/x-java-source',     
        'text/html',             
        'text/css',               
        'application/x-httpd-php',
        'text/x-csrc',            
        'text/x-c++src',          
        'application/json',    
        'application/x-yaml',     
        'application/x-ruby',     
        'application/x-sh',       
        'application/sql',      
    ];
    if (!allowedMimetypes.includes(file.mimetype)) {
      return cb(new Error('File type not allowed.'), false , file.filename);
    }
    cb(null, true);
  },
}).fields([{ name: 'files', maxCount: 10 }]);

module.exports = {
  uploadFields: upload,
};