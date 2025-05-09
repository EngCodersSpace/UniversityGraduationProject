// controllers/importController.js

const xlsx = require('xlsx');
const fs = require('fs');
const path = require('path');
const db = require('../models'); 
const { reconstructMultilingualFields } = require('../utils/excelHelper');

async function importData(req, res) {
  try {
    const file = req.file;

    if (!file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    const workbook = xlsx.readFile(file.path);
    const sheetNames = workbook.SheetNames;

    const result = {};

    for (const sheetName of sheetNames) {
      const tableName = sheetName.toLowerCase(); 
      const worksheet = workbook.Sheets[sheetName];
      const jsonData = xlsx.utils.sheet_to_json(worksheet);

      const model = db[tableName];
      if (!model) {
        result[tableName] = 'Model not found, skipped.';
        continue;
      }

      // Prepare and insert each row
      const inserted = [];
      for (const row of jsonData) {
        const processedRow = reconstructMultilingualFields(row);
        const created = await model.create(processedRow);
        inserted.push(created.id || created);
      }

      result[tableName] = `Imported ${inserted.length} records.`;
    }

    // Clean up uploaded file
    fs.unlinkSync(file.path);

    return res.status(200).json({ message: 'Import completed', result });
  } catch (error) {
    console.error('Import error:', error);
    return res.status(500).json({ error: 'Import failed', details: error.message });
  }
}

module.exports = {
  importData,
};