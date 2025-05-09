// // controllPanel.js
// const xlsx = require("xlsx");
// const fs = require("fs");
// const path = require("path");
// const { sequelize } = require("../models"); 
// const models = require("../models"); 
// const { ValidationError, UniqueConstraintError, ForeignKeyConstraintError } = require('sequelize');

// const { uploadExcel  } = require('../utils/multerConfig');
// const { readExcelFile,writeExcelFile } = require('../middleware/excelService');
// const { insertData } = require('../middleware/dbService');
// const ExcelJS = require('exceljs');
// const { exportData , getProcessingOrder} = require('./dbService');


// // Centralized error handler (can i use it as middleware later)
// const handleSequelError = (error, res) => {
//     let status = 500;
//     let message = 'Internal server error';
  
//     if (error instanceof UniqueConstraintError) {
//       status = 400;
//       message = `Duplicate entry: ${error.message}`;
//     } else if (error instanceof ForeignKeyConstraintError) {
//       status = 400;
//       message = `Foreign key violation: ${error.message}`;
//     } else if (error instanceof ValidationError) {
//       status = 400;
//       message = `Validation failed: ${error.message}`;
//     } else {
//       message = error.message;
//     }
  
//     res.status(status).send({ message });
// };


// exports.uploadExcelFile = async (req, res) => {
//   try {
//     const folder = 'temp';
//     const subfolder = 'ExcelFiles';

//     uploadExcel(folder, subfolder).single('file')(req, res, async (err) => {
//       if (err) {
//         return res.status(400).send({ message: 'Error uploading file' });
//       }

//       try {
//         const filePath = req.file.path;
//         const sheetsData = readExcelFile(filePath);
//         const skippedRecords = [];
        
//         // Define mandatory processing order
//         // const processingOrder = [
//         //   'user',         // Parent table
//         //   'student',      // Depends on user
//         //   'doctor',       // Depends on user
//         // ];

//         const processingOrder = getProcessingOrder(models);


//         // Process sheets in strict order
//         for (const sheetName of processingOrder) {
//           if (sheetsData[sheetName]) {
//             for (const row of sheetsData[sheetName]) {
//               const result = await insertData(sheetName, row);
//               if (result.status === 'skipped') {
//                 skippedRecords.push({
//                   sheet: sheetName,
//                   record: row,
//                   reason: result.reason,
//                 });
//               }
//             }
//           }
//         }

//         fs.unlink(filePath, (err) => {
//           if (err) {
//             console.error('Error deleting file:', err);
//             return res.status(500).send({ message: 'Error deleting file after processing' });
//           }

//           console.log('File deleted successfully:', filePath);
//           res.status(200).send({
//             message: 'File uploaded and processed successfully',
//             skippedRecords,
//           });
//         });

//       } catch (error) {
//         fs.unlink(req.file.path, (err) => {
//           if (err) console.error('Error deleting file on error:', err);
//         });
//         handleSequelError(error, res);
//       }
//     });
//   } catch (error) {
//     handleSequelError(error, res);
//   }
// };


// exports.exportToExcel = async (req, res) => {
//   try {
//     const folder = 'imports';
//     const filename = `import_${Date.now()}.xlsx`;

//     if (!fs.existsSync(folder)) fs.mkdirSync(folder);

//     const sheets = ['user', 'student', 'doctor'];
//     const dataBySheet = {};

//     for (const modelName of sheets) {
//       const Model = db[modelName];
//       if (!Model) continue;

//       const records = await Model.findAll({ raw: true });
//       dataBySheet[modelName] = records;
//     }

//     const filePath = writeExcelFile(dataBySheet, folder, filename);
    
//     res.download(filePath, filename, (err) => {
//       if (err) {
//         console.error('Download error:', err);
//         res.status(500).send({ message: 'Failed to download file' });
//       }

//       // Optionally delete after download
//       // fs.unlink(filePath, () => {});
//     });

//   } catch (error) {
//     console.error('Export error:', error);
//     res.status(500).send({ message: 'Server error during export' });
//   }
// };


// const exportHandler = async (req, res) => {
//   const modelName = req.params.model;
//   try {
//     const rows = await exportData(modelName);

//     const workbook = new ExcelJS.Workbook();
//     const worksheet = workbook.addWorksheet(modelName);
//     if (rows.length) {
//       worksheet.columns = Object.keys(rows[0]).map(key => ({ header: key, key }));
//       worksheet.addRows(rows);
//     }

//     const filename = `${modelName}_export.xlsx`;
//     res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
//     res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

//     await workbook.xlsx.write(res);
//     res.end();
//   } catch (error) {
//     res.status(500).json({ error: error.message });
//   }
// };







// const fs = require('fs');
// const path = require('path');
// const ExcelJS = require('exceljs');
// const { sequelize } = require("../models");
// const models = require("../models");
// const { 
//   ValidationError, 
//   UniqueConstraintError, 
//   ForeignKeyConstraintError 
// } = require('sequelize');

// const { uploadExcel } = require('../utils/multerConfig');
// const { readExcelFile, writeExcelFile } = require('../middleware/excelService');
// const { 
//   insertData, 
//   exportData,
//   validateExportRequest,
//   getModelRelationships
// } = require('../middleware/dbService');

// const handleSequelError = (err, req, res, next) => {
//   let status = 500;
//   let message = 'Internal server error';

//   if (err instanceof UniqueConstraintError) {
//     status = 400;
//     message = `Duplicate entry: ${err.message}`;
//   } else if (err instanceof ForeignKeyConstraintError) {
//     status = 400;
//     message = `Foreign key violation: ${err.message}`;
//   } else if (err instanceof ValidationError) {
//     status = 400;
//     message = `Validation failed: ${err.errors.map(e => e.message).join(', ')}`;
//   } else {
//     message = err.message;
//   }

//   res.status(status).json({ 
//     success: false,
//     error: message,
//     stack: process.env.NODE_ENV === 'development' ? err.stack : undefined
//   });
// };

// exports.uploadExcelFile = async (req, res, next) => {
//   const folder = 'temp';
//   const subfolder = 'ExcelFiles';
//   const sourceLanguage = req.headers['accept-language']?.startsWith('ar') ? 'ar' : 'en';
  
//   uploadExcel(folder, subfolder).single('file')(req, res, async (err) => {
//     if (err) {
//       return res.status(400).json({ 
//         success: false,
//         message: 'Error uploading file',
//         error: err.message 
//       });
//     }

//     const transaction = await sequelize.transaction();
//     try {
//       const filePath = req.file.path;
//       const sheetsData = await readExcelFile(filePath, sourceLanguage);
//       const results = {
//         inserted: 0,
//         skipped: 0,
//         skippedRecords: []
//       };

//       // Get processing order based on model relationships
//       const processingOrder = getModelRelationships();
      
//       for (const sheetName of processingOrder) {
//         if (sheetsData[sheetName]) {
//           for (const row of sheetsData[sheetName]) {
//             const result = await insertData(sheetName, row, { 
//               transaction,
//               language: sourceLanguage 
//             });
            
//             if (result.status === 'inserted') {
//               results.inserted++;
//             } else {
//               results.skipped++;
//               results.skippedRecords.push({
//                 sheet: sheetName,
//                 record: row,
//                 reason: result.reason,
//               });
//             }
//           }
//         }
//       }

//       await transaction.commit();
      
//       // Clean up file
//       fs.unlink(filePath, (err) => {
//         if (err) console.error('Error deleting file:', err);
//       });

//       res.status(200).json({
//         success: true,
//         message: 'File processed successfully',
//         data: results
//       });

//     } catch (error) {
//       await transaction.rollback();
//       fs.unlink(req.file.path, (err) => {
//         if (err) console.error('Error deleting file on error:', err);
//       });
//       next(error);
//     }
//   });
// };

// exports.exportToExcel = async (req, res, next) => {
//   try {
//     const { models: requestedModels, format = 'xlsx' } = req.query;
//     const targetLanguage = req.headers['accept-language']?.startsWith('ar') ? 'ar' : 'en';
//     const folder = 'exports';
//     const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
//     const filename = `export_${timestamp}.${format}`;

//     if (!fs.existsSync(folder)) fs.mkdirSync(folder, { recursive: true });

//     // Validate requested models
//     const validModels = validateExportRequest(requestedModels);
//     const dataBySheet = {};

//     // Parallel data fetching with language preference
//     await Promise.all(validModels.map(async (modelName) => {
//       dataBySheet[modelName] = await exportData(modelName, {
//         language: targetLanguage,
//         attributes: req.query.attributes,
//         where: req.query.filters
//       });
//     }));

//     if (format === 'xlsx') {
//       const filePath = writeExcelFile(dataBySheet, folder, filename);
      
//       res.download(filePath, filename, (err) => {
//         if (err) next(err);
//         // Optionally delete after download
//         if (process.env.NODE_ENV !== 'development') {
//           fs.unlink(filePath, () => {});
//         }
//       });
//     } else if (format === 'json') {
//       res.json({
//         success: true,
//         data: dataBySheet
//       });
//     } else {
//       throw new Error('Unsupported export format');
//     }

//   } catch (error) {
//     next(error);
//   }
// };

// exports.exportHandler = async (req, res, next) => {
//   try {
//     const { model } = req.params;
//     const { format = 'xlsx' } = req.query;
//     const targetLanguage = req.headers['accept-language']?.startsWith('ar') ? 'ar' : 'en';

//     const data = await exportData(model, {
//       language: targetLanguage,
//       include: req.query.include,
//       attributes: req.query.attributes,
//       where: req.query.filters
//     });

//     if (format === 'json') {
//       return res.json({
//         success: true,
//         data
//       });
//     }

//     const workbook = new ExcelJS.Workbook();
//     const worksheet = workbook.addWorksheet(model);
    
//     if (data.length) {
//       // Auto-detect columns with proper headers
//       worksheet.columns = Object.keys(data[0]).map(key => ({
//         header: key.replace(/([A-Z])/g, ' $1').replace(/^./, str => str.toUpperCase()),
//         key,
//         width: key.length + 5
//       }));
      
//       worksheet.addRows(data);
//     }

//     const filename = `${model}_export_${Date.now()}.xlsx`;
//     res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
//     res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

//     await workbook.xlsx.write(res);
//     res.end();

//   } catch (error) {
//     next(error);
//   }
// };




const { getAllModelData } = require('../middleware/dbService');
const { createExcelFile } = require('../middleware/excelService');
const fs = require('fs');
const path = require('path');


// Helper function to clean up files
function cleanupFile(filePath) {
  try {
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
    }
  } catch (err) {
    console.error('Error cleaning up file:', err);
  }
}

exports.downloadToExcel = async (req, res) => {
  try {
    // 1. Get all data from database
    const allData = await getAllModelData();
    
    // 2. Create Excel file with robust error handling
    const filePath = await createExcelFile(allData);
    const filename = path.basename(filePath);
    
    // 3. Set proper headers for Excel download
    res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    res.setHeader('Content-Disposition', `attachment; filename=${filename}`);
    
    // 4. Stream the file with error handling
    const fileStream = fs.createReadStream(filePath);
    fileStream.pipe(res);
    
    fileStream.on('error', (err) => {
      console.error('File stream error:', err);
      if (!res.headersSent) {
        res.status(500).json({
          success: false,
          message: 'Error streaming Excel file'
        });
      }
      cleanupFile(filePath);
    });
    
    res.on('finish', () => {
      cleanupFile(filePath);
    });
    
  } catch (error) {
    console.error('Export failed:', error);
    res.status(500).json({
      success: false,
      message: 'Database export failed',
      error: error.message
    });
  }
};
