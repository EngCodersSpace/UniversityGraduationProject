const xlsx = require("xlsx");
const fs = require("fs");
const path = require("path");
const { sequelize } = require("../models"); 
const models = require("../models"); 
const { ValidationError, UniqueConstraintError, ForeignKeyConstraintError } = require('sequelize');

const { uploadExcel  } = require('../utils/multerConfig');
const { readExcelFile } = require('../middleware/excelService');
const { insertData } = require('../middleware/dbService');

// Centralized error handler (can i use it as middleware later)
const handleSequelError = (error, res) => {
    let status = 500;
    let message = 'Internal server error';
  
    if (error instanceof UniqueConstraintError) {
      status = 400;
      message = `Duplicate entry: ${error.message}`;
    } else if (error instanceof ForeignKeyConstraintError) {
      status = 400;
      message = `Foreign key violation: ${error.message}`;
    } else if (error instanceof ValidationError) {
      status = 400;
      message = `Validation failed: ${error.message}`;
    } else {
      message = error.message;
    }
  
    res.status(status).send({ message });
};


exports.uploadExcelFile = async (req, res) => {
  try {
    const folder = 'temp';
    const subfolder = 'ExcelFiles';

    uploadExcel(folder, subfolder).single('file')(req, res, async (err) => {
      if (err) {
        return res.status(400).send({ message: 'Error uploading file' });
      }

      try {
        const filePath = req.file.path;
        const sheetsData = readExcelFile(filePath);
        const skippedRecords = [];
        
        // Define mandatory processing order
        const processingOrder = [
          'user',         // Parent table
          'student',      // Depends on user
          'doctor',       // Depends on user
        ];

        // Process sheets in strict order
        for (const sheetName of processingOrder) {
          if (sheetsData[sheetName]) {
            for (const row of sheetsData[sheetName]) {
              const result = await insertData(sheetName, row);
              if (result.status === 'skipped') {
                skippedRecords.push({
                  sheet: sheetName,
                  record: row,
                  reason: result.reason,
                });
              }
            }
          }
        }

        // after insertion - delete excel file
        fs.unlink(filePath, (err) => {
          if (err) {
            console.error('Error deleting file:', err);
            return res.status(500).send({ message: 'Error deleting file after processing' });
          }

          console.log('File deleted successfully:', filePath);
          res.status(200).send({
            message: 'File uploaded and processed successfully',
            skippedRecords,
          });
        });

      } catch (error) {
        fs.unlink(req.file.path, (err) => {
          if (err) console.error('Error deleting file on error:', err);
        });
        handleSequelError(error, res);
      }
    });
  } catch (error) {
    handleSequelError(error, res);
  }
};