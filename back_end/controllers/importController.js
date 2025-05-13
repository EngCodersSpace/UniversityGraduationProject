// controllers/importController.js
const xlsx = require('xlsx');
const fs = require('fs');
const db = require('../models');
const { reconstructMultilingualFields } = require('../utils/excelHelper');
const { ValidationError, UniqueConstraintError, ForeignKeyConstraintError } = require('sequelize');


async function importData(req, res) {
  const file = req.file;

  if (!file) {
    return res.status(400).json({ error: 'No file uploaded' });
  }

  // const workbook = xlsx.readFile(file.path);
  const workbook = xlsx.read(file.buffer, { type: 'buffer' });
  const sheetNames = workbook.SheetNames;
  const result = {};

  const transaction = await db.sequelize.transaction();

  try {
    for (const sheetName of sheetNames) {
      const tableName = sheetName.toLowerCase();
      const worksheet = workbook.Sheets[sheetName];
      const jsonData = xlsx.utils.sheet_to_json(worksheet);

      const model = db[tableName];
      if (!model) {
        result[tableName] = 'Model not found, skipped.';
        continue;
      }

      const inserted = [];

      for (const row of jsonData) {
        const processedRow = reconstructMultilingualFields(row);

        // Update if ID exists, otherwise create
        if (processedRow.id) {
          const [updated] = await model.update(processedRow, {
            where: { id: processedRow.id },
            transaction,
          });

          if (updated === 0) {
            const created = await model.create(processedRow, { transaction });
            inserted.push(created.id || created);
          } else {
            inserted.push(processedRow.id); // updated row
          }
        } else {
          const created = await model.create(processedRow, { transaction });
          inserted.push(created.id || created);
        }
      }

      result[tableName] = `Imported/Updated ${inserted.length} records.`;
    }

    await transaction.commit();
    fs.unlinkSync(file.path); // Delete uploaded file
    return res.status(200).json({ message: 'Import completed', result });

  } catch (error) {
    await transaction.rollback();
    if (error instanceof UniqueConstraintError) {
      return res.status(400).json({ message: 'Duplicate entry error: ' + error.message });
    }

    if (error instanceof ForeignKeyConstraintError) {
      return res.status(400).json({ message: 'Foreign key violation: ' + error.message });
    }

    if (error instanceof ValidationError) {
      return res.status(400).json({ message: 'Validation error: ' + error.message });
    }

    console.error('Import error:', error);
    return res.status(500).json({ error: 'Import failed', details: error.message });
  }
}

module.exports = {
  importData,
};