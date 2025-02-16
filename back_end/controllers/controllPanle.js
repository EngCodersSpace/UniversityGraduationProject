const xlsx = require("xlsx");
const fs = require("fs");
const path = require("path");
const { sequelize } = require("../models"); // Import database connection
const models = require("../models"); // Load all Sequelize models
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

        res.status(200).send({
          message: 'File uploaded successfully',
          skippedRecords
        });

      } catch (error) {
        handleSequelError(error, res);
      }
    });
  } catch (error) {
    handleSequelError(error, res);
  }
};