// utils/multerConfig.js
const crypto = require('crypto');
const multer = require('multer');
const fs = require('fs');
const path = require('path');

const createFolderIfNotExists = async (folderPath) => {
  try {
    await fs.promises.access(folderPath);
  } catch {
    await fs.promises.mkdir(folderPath, { recursive: true });
  }
};

const getStorageForPath = (baseFolder = 'temp') => {
  return {
    _handleFile(req, file, cb) {
      const folderPath = path.join(__dirname, '../storage', baseFolder);

      const hash = crypto
        .createHash('md5')
        .update(`${file.originalname}-${Date.now()}`)
        .digest('hex');
      const fileExtension = path.extname(file.originalname);
      const hashedFileName = `${hash}${fileExtension}`;
      const finalFilePath = path.join(folderPath, hashedFileName);

      createFolderIfNotExists(folderPath)
        .then(() => {
          const writeStream = fs.createWriteStream(finalFilePath);
          file.stream.pipe(writeStream);

          writeStream.on('finish', async () => {
            try {
              const fileMetadata = {
                originalName: file.originalname,
                mimeType: file.mimetype,
                size: writeStream.bytesWritten,
                path: finalFilePath, 
                hash, 
              };

              console.log(`File successfully uploaded: ${finalFilePath}`);
              cb(null, fileMetadata);
            } catch (error) {
              cb(error);
            }
          });

          writeStream.on('error', (err) => {
            console.error('Error writing file:', err.message);
            cb(err);
          });
        })
        .catch((err) => {
          cb(err);
        });
    },

    _removeFile(req, file, cb) {
      const filePath = file.path;

      fs.unlink(filePath, (err) => {
        if (err) return cb(err);
        cb(null);
      });
    },
  };
};

const createUploadMiddleware = (baseFolder) => {
  const storage = getStorageForPath(baseFolder);
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
  return multer({
    storage,
    fileFilter: (req, file, cb) => {
      if (!allowedMimetypes.includes(file.mimetype)) {
        return cb(new Error('File type not allowed.'), false);
      }
      cb(null, true);
    },
  });
};

module.exports = {
  uploadFields: createUploadMiddleware,
  createFolderIfNotExists,
};