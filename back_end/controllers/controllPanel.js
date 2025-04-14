// controllPanle.js

const xlsx = require("xlsx");
const fs = require("fs");
const path = require("path");
const { sequelize } = require("../models");
const models = require("../models");
const { ValidationError, UniqueConstraintError, ForeignKeyConstraintError } = require('sequelize');

const { uploadExcel } = require('../utils/multerConfig');
const { readExcelFile } = require('../middleware/excelService');
const { getProcessingOrder } = require('../middleware/dbService');

// Centralized error handler
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

// Upload and process Excel file
exports.uploadExcelFile = async (req, res) => {
  try {
    uploadExcel().single('file')(req, res, async (err) => {
      if (err) {
        return res.status(400).send({ message: 'Error uploading file' });
      }

      try {
        const filePath = req.file.path;
        const sheetsData = readExcelFile(filePath);

        // Dynamically determine processing order
        const processingOrder = getProcessingOrder(models);

        const skippedRecords = [];
        const insertionStats = {};

        // Process sheets in the correct order
        await sequelize.transaction(async (t) => {
          for (const modelName of processingOrder) {
            if (!sheetsData[modelName]) continue;

            const Model = models[modelName];
            const results = await Model.bulkCreate(sheetsData[modelName], {
              validate: true,
              individualHooks: true,
              transaction: t,
              ignoreDuplicates: true,
              returning: false,
            });

            insertionStats[modelName] = {
              inserted: results.length,
              skipped: sheetsData[modelName].length - results.length,
            };
          }
        });

        // Delete the file after processing
        fs.unlink(filePath, (err) => {
          if (err) {
            console.error('Error deleting file:', err);
            return res.status(500).send({ message: 'Error deleting file after processing' });
          }

          console.log('File deleted successfully:', filePath);
          res.status(200).send({
            message: 'File uploaded and processed successfully',
            stats: insertionStats,
            skippedRecords,
          });
        });

      } catch (error) {
        // Clean up file on error
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

// Export All databace to Excel or with filters ...
exports.exportData = async (req, res) => {
  try {
    const { tableNames, ids, includeRelated } = req.body; // Input from frontend

    const workbook = xlsx.utils.book_new();

    // If no specific tables are requested, export all tables
    const modelsToExport = tableNames && tableNames.length > 0
      ? tableNames.map(name => models[name]).filter(Boolean) // Filter valid models
      : Object.values(models).filter(model => !model.name.endsWith('_history')); // Exclude history tables

    // Export each requested table
    await Promise.all(modelsToExport.map(async (model) => {
      const modelName = model.name;

      // Build the query based on input
      let query = {
        raw: true,
        attributes: { exclude: ['password'] }, // Skip sensitive fields
      };

      // Filter by IDs if provided
      if (ids && ids[modelName]) {
        query.where = { id: ids[modelName] };
      }

      // Include related data if requested
      if (includeRelated && includeRelated[modelName]) {
        query.include = includeRelated[modelName].map(relatedModel => ({
          model: models[relatedModel],
          as: relatedModel.toLowerCase(),
        }));
      }

      // Fetch data
      const data = await model.findAll(query);

      // Add data to Excel sheet
      const worksheet = xlsx.utils.json_to_sheet(data);
      xlsx.utils.book_append_sheet(workbook, worksheet, modelName);
    }));

    // Send the Excel file as a response
    const buffer = xlsx.write(workbook, { type: 'buffer' });
    res.attachment('export.xlsx');
    res.send(buffer);

  } catch (error) {
    handleSequelError(error, res);
  }
};