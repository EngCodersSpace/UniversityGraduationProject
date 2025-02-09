// utils/multerConfig.js
const crypto = require('crypto');
const multer = require('multer');
const fs = require('fs');
const path = require('path');

require('dotenv').config(); 

const createFolderIfNotExists = async (folderPath) => {
  try {
    await fs.promises.access(folderPath);
  } catch {
    await fs.promises.mkdir(folderPath, { recursive: true });
  }
};

const getStorageForPath = (baseFolder = 'temp', subFolder) => {
  return {
    _handleFile(req, file, cb) {
      const folderPath = path.resolve('storage', baseFolder, subFolder);
      const hash = crypto.createHash('md5').update(file.originalname + file.size).digest('hex');
      let finalFileName = `${hash}${path.extname(file.originalname)}`;
      let finalFilePath = path.join(folderPath, finalFileName);

      createFolderIfNotExists(folderPath)
        .then(() => {
          const writeStream = fs.createWriteStream(finalFilePath);
          
          writeStream.on('error', (err) => {
            console.error('Error writing file:', err.message);
            cb(err);
          });

          writeStream.on('finish', () => {
            try {

              const newhash = crypto.createHash('md5').update(file.originalname + writeStream.bytesWritten).digest('hex');
              const newFileName = `${newhash}${path.extname(file.originalname)}`;
              const newFilePath = path.join(folderPath, newFileName);
              fs.renameSync(finalFilePath, newFilePath);
              
              finalFileName = newFileName;
              finalFilePath = newFilePath;

              const fileMetadata = {
                originalName: file.originalname,
                mimeType: file.mimetype,
                size: writeStream.bytesWritten,
                path: `${baseFolder}/${subFolder}/${finalFileName}`,
                hash:newhash,
              };

              console.log(`File successfully uploaded: ${path}`);
              cb(null, fileMetadata);
            } catch (error) {
              cb(error);
            }
          });

          file.stream.on('error', (err) => {
            console.error('Error reading file:', err.message);
            writeStream.destroy(); 
            cb(err);
          });

          file.stream.pipe(writeStream);
        })
        .catch((err) => {
          console.error('Error creating folder:', err.message);
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

const getStorageForPathPhoto = (baseFolder = 'temp', subFolder) => {
  return multer.diskStorage({
    destination: async (req, file, cb) => {
      const folderPath = path.resolve('storage', baseFolder, subFolder);
      await createFolderIfNotExists(folderPath);
      cb(null, folderPath);
    },
    filename: (req, file, cb) => {
      // const hash = crypto.createHash('md5').update(file.originalname).digest('hex');
      const fileName = `${path.extname(file.originalname)}`;
      cb(null, fileName);
    },
  });
};

const createUploadMiddleware = (baseFolder,subFolder) => {
  const storage = getStorageForPath(baseFolder,subFolder);

  // const allowedMimetypes = [
  //   'image/jpeg',
  //   'image/png',
  //   'image/gif',
  //   'image/bmp',
  //   'image/webp',
  //   'image/svg+xml',
  //   'image/tiff',
  //   'image/x-icon',
  
  //   'application/pdf',
  
  //   'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  //   'application/msword',
  //   'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  //   'application/vnd.ms-excel',
  //   'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  //   'application/vnd.ms-powerpoint',
  
  //   'video/mp4',
  //   'video/x-msvideo',
  //   'video/x-m4v',
  //   'video/mpeg',
  //   'video/quicktime',
  //   'video/x-ms-wmv',
  //   'video/ogg',
  //   'video/webm',
  
  //   'audio/mpeg',
  //   'audio/wav',
  //   'audio/ogg',
  
  //   'application/zip',
  //   'application/x-rar-compressed',
  
  //   'text/csv',
  
  //   'application/javascript', 
  //   'text/x-python',          
  //   'text/x-java-source',     
  //   'text/html',             
  //   'text/css',               
  //   'application/x-httpd-php',
  //   'text/x-csrc',            
  //   'text/x-c++src',          
  //   'application/json',    
  //   'application/x-yaml',     
  //   'application/x-ruby',     
  //   'application/x-sh',       
  //   'application/sql',      
  // ];
  return multer({
    storage,
    // fileFilter: (req, file, cb) => {
    //   if (!allowedMimetypes.includes(file.mimetype)) {
    //     return cb(new Error('File type not allowed.'), false);
    //   }
    //   cb(null, true);
    // },
  });
};


const uploadPhoto = (baseFolder,subFolder)=>{
  const storagePhoto = getStorageForPathPhoto(baseFolder,subFolder);
  return multer({
    storagePhoto,
  });
}

module.exports = {
  uploadFields: createUploadMiddleware,
  createFolderIfNotExists,
  uploadPhoto
};