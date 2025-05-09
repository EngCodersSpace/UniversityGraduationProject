// controllers/exportController.js
const ExcelJS = require('exceljs');
const db = require('../models');
const { flattenMultilingualFields } = require('../utils/excelHelper');
const { applyFiltersToQuery } = require('../utils/filterParser');
const { getTableRelations } = require('../utils/relationHelper');

exports.exportData = async (req, res) => {
  try {
    let lang =req.headers["Accept-language"] === "en" ? "ar" : "en";
    let { tables = '', relations = 'false'} = req.query;
    
    const includeRelations = relations === 'true';

    let parsedTables = [];

    if (tables === 'all') {
      parsedTables = Object.keys(db).filter(key => typeof db[key].findAll === 'function');
    } else {
      parsedTables = tables.split(',').map(t => t.trim()).filter(Boolean);
    }

    if (parsedTables.length === 0) {
      return res.status(400).json({ message: 'No tables specified or found' });
    }

    res.setHeader(
      'Content-Disposition',
      `attachment; filename="exported_data.xlsx"`
    );
    res.setHeader(
      'Content-Type',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    );

    const workbook = new ExcelJS.stream.xlsx.WorkbookWriter({ stream: res });

    for (const tableName of parsedTables) {
      const model = db[tableName];
      if (!model) {
        console.warn(`Table '${tableName}' does not exist`);
        continue;
      }

      const queryOptions = {};

      if (includeRelations) {
        const includes = getTableRelations(tableName, db); // your custom logic
        if (includes.length > 0) queryOptions.include = includes;
      }

      const records = await model.findAll(queryOptions);
      const flatData = records.map(item =>
        flattenMultilingualFields(item.toJSON(), lang)
      );
      
      if (flatData.length === 0) continue;

      const worksheet = workbook.addWorksheet(tableName);
      worksheet.columns = Object.keys(flatData[0]).map(key => ({ header: key, key }));
      

      for (const row of flatData) {
        worksheet.addRow(row).commit();
      }

      worksheet.commit();
    }

    await workbook.commit();
  } catch (error) {
    console.error('Export failed:', error);
    if (!res.headersSent) {
      res.status(500).json({ message: 'Export failed', error: error.message });
    }
  }
};