// excelService.js
// const xlsx = require('xlsx');
// const path = require('path');

// const readExcelFile = (filePath) => {
//   const workbook = xlsx.readFile(filePath);
//   const sheetsData = {};

//   workbook.SheetNames.forEach((sheetName) => {
//     const sheet = workbook.Sheets[sheetName];
//     sheetsData[sheetName] = xlsx.utils.sheet_to_json(sheet);
//   });

//   return sheetsData;
// };

// const writeExcelFile = (dataBySheet, folder, filename) => {
//   const workbook = xlsx.utils.book_new();

//   for (const [sheetName, rows] of Object.entries(dataBySheet)) {
//     const worksheet = xlsx.utils.json_to_sheet(rows);
//     xlsx.utils.book_append_sheet(workbook, worksheet, sheetName);
//   }

//   const fullPath = path.join(folder, filename);
//   xlsx.writeFile(workbook, fullPath);

//   return fullPath;
// };


// module.exports = { readExcelFile ,writeExcelFile};



// const xlsx = require('xlsx');
// const path = require('path');
// const ExcelJS = require('exceljs');
// const { translateText } = require("../middleware/translationServices");

// const processBilingualFields = async (data, sourceLanguage) => {
//   const targetLanguage = sourceLanguage === 'en' ? 'ar' : 'en';
//   const result = {};
  
//   for (const [key, value] of Object.entries(data)) {
//     if (typeof value === 'string' && value.trim() !== '') {
//       try {
//         result[key] = {
//           [sourceLanguage]: value,
//           [targetLanguage]: await translateText(value, sourceLanguage, targetLanguage)
//         };
//       } catch (error) {
//         console.error(`Translation failed for ${key}: ${value}`, error);
//         result[key] = { [sourceLanguage]: value };
//       }
//     } else {
//       result[key] = value;
//     }
//   }
  
//   return result;
// };

// const readExcelFile = async (filePath, language = 'en') => {
//   const workbook = xlsx.readFile(filePath);
//   const sheetsData = {};

//   for (const sheetName of workbook.SheetNames) {
//     const sheet = workbook.Sheets[sheetName];
//     const rows = xlsx.utils.sheet_to_json(sheet);
    
//     sheetsData[sheetName] = await Promise.all(rows.map(async row => {
//       return await processBilingualFields(row, language);
//     }));
//   }

//   return sheetsData;
// };

// const writeExcelFile = (dataBySheet, folder, filename, options = {}) => {
//   try {
//     const workbook = xlsx.utils.book_new();
//     const fullPath = path.join(folder, filename);

//     for (const [sheetName, rows] of Object.entries(dataBySheet)) {
//       if (rows && rows.length > 0) {
//         const worksheet = xlsx.utils.json_to_sheet(rows, {
//           header: Object.keys(rows[0]),
//           ...options
//         });
//         xlsx.utils.book_append_sheet(workbook, worksheet, sheetName);
//       }
//     }

//     xlsx.writeFile(workbook, fullPath, {
//       bookType: 'xlsx',
//       ...options
//     });

//     return fullPath;
//   } catch (error) {
//     console.error('Error writing Excel file:', error);
//     throw new Error('Failed to generate Excel file');
//   }
// };

// const generateExcelBuffer = async (dataBySheet) => {
//   const workbook = new ExcelJS.Workbook();

//   for (const [sheetName, rows] of Object.entries(dataBySheet)) {
//     if (rows && rows.length > 0) {
//       const worksheet = workbook.addWorksheet(sheetName);
      
//       // Auto-detect columns
//       const columns = Object.keys(rows[0]).map(key => ({
//         header: key.replace(/([A-Z])/g, ' $1').replace(/^./, str => str.toUpperCase()),
//         key,
//         width: key.length + 10
//       }));

//       worksheet.columns = columns;
//       worksheet.addRows(rows);

//       // Auto-fit columns
//       columns.forEach((_, i) => {
//         worksheet.getColumn(i + 1).eachCell({ includeEmpty: true }, cell => {
//           const maxLength = Math.max(
//             cell.value ? cell.value.toString().length : 0,
//             worksheet.getColumn(i + 1).header.length
//           );
//           worksheet.getColumn(i + 1).width = Math.min(maxLength + 2, 50);
//         });
//       });
//     }
//   }

//   return workbook.xlsx.writeBuffer();
// };

// module.exports = { 
//   readExcelFile,
//   writeExcelFile,
//   generateExcelBuffer
// };


// const xlsx = require('xlsx');
// const path = require('path');
// const { translateText } = require('./translationServices');

// const isTranslationNeeded = (value) => {
//   return typeof value === 'object' && 
//          value !== null &&
//          !Array.isArray(value) &&
//          !(value instanceof Date) &&
//          !('en' in value) && 
//          !('ar' in value);
// };

// const processRow = async (row, sourceLanguage) => {
//   const targetLanguage = sourceLanguage === 'ar' ? 'en' : 'ar';
//   const processedRow = {};

//   for (const [key, value] of Object.entries(row)) {
//     if (isTranslationNeeded(value)) {
//       // Process only JSON objects that need translation
//       processedRow[key] = {};
//       for (const [subKey, subValue] of Object.entries(value)) {
//         if (typeof subValue === 'string') {
//           try {
//             processedRow[key][subKey] = {
//               [sourceLanguage]: subValue,
//               [targetLanguage]: await translateText(subValue, sourceLanguage, targetLanguage)
//             };
//           } catch (error) {
//             console.error(`Translation failed for ${key}.${subKey}:`, error);
//             processedRow[key][subKey] = { [sourceLanguage]: subValue };
//           }
//         } else {
//           // Non-string values in JSON remain unchanged
//           processedRow[key][subKey] = subValue;
//         }
//       }
//     } else {
//       // Non-JSON values remain exactly as they are
//       processedRow[key] = value;
//     }
//   }

//   return processedRow;
// };

// const readExcelFile = async (filePath, sourceLanguage = 'en') => {
//   const workbook = xlsx.readFile(filePath, { cellDates: true });
//   const sheetsData = {};

//   for (const sheetName of workbook.SheetNames) {
//     const sheet = workbook.Sheets[sheetName];
//     let rows = xlsx.utils.sheet_to_json(sheet, { defval: null, raw: false });

//     // Parse potential JSON strings
//     rows = rows.map(row => {
//       const parsedRow = {};
//       for (const [key, value] of Object.entries(row)) {
//         try {
//           parsedRow[key] = (typeof value === 'string' && 
//                           /^[\{\[].*[\}\]]$/.test(value.trim()))
//                           ? JSON.parse(value) 
//                           : value;
//         } catch {
//           parsedRow[key] = value;
//         }
//       }
//       return parsedRow;
//     });

//     sheetsData[sheetName] = await Promise.all(
//       rows.map(row => processRow(row, sourceLanguage))
//     );
//   }

//   return sheetsData;
// };

// const writeExcelFile = (dataBySheet, folder, filename, language = 'en') => {
//   const workbook = xlsx.utils.book_new();
//   const fullPath = path.join(folder, filename);

//   for (const [sheetName, rows] of Object.entries(dataBySheet)) {
//     if (rows?.length > 0) {
//       const flattenedRows = rows.map(row => {
//         const flatRow = {};
//         for (const [key, value] of Object.entries(row)) {
//           if (isTranslationNeeded(value)) {
//             // Flatten translated JSON objects
//             flatRow[key] = JSON.stringify(
//               Object.fromEntries(
//                 Object.entries(value).map(([k, v]) => [
//                   k,
//                   (typeof v === 'object' && ('en' in v || 'ar' in v))
//                     ? v[language] || v.en || v.ar || ''
//                     : v
//                 ])
//               )
//             );
//           } else {
//             // Keep non-JSON values as-is
//             flatRow[key] = (typeof value === 'object' && value !== null)
//               ? JSON.stringify(value)
//               : value;
//           }
//         }
//         return flatRow;
//       });

//       const worksheet = xlsx.utils.json_to_sheet(flattenedRows);
//       xlsx.utils.book_append_sheet(workbook, worksheet, sheetName);
//     }
//   }

//   xlsx.writeFile(workbook, fullPath);
//   return fullPath;
// };

// module.exports = { readExcelFile, writeExcelFile };






const ExcelJS = require('exceljs');
const path = require('path');
const fs = require('fs');

const createExcelFile = async (data) => {
  const folder = 'storage/exports';
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const filename = `db_export_${timestamp}.xlsx`;
  const filePath = path.join(folder, filename);

  // Ensure storage directory exists
  if (!fs.existsSync(folder)) {
    fs.mkdirSync(folder, { recursive: true });
  }

  // Create workbook with proper Excel compatibility settings
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'University System';
  workbook.lastModifiedBy = 'University System';
  workbook.created = new Date();
  workbook.modified = new Date();
  
  // Add core properties for better Excel compatibility
  workbook.properties = {
    company: 'University',
    application: 'Database Export System'
  };

  // Process each model
  for (const [modelName, records] of Object.entries(data)) {
    if (records.length > 0) {
      const worksheet = workbook.addWorksheet(modelName.replace(/[\\*?:/[\]]/g, '_'), {
        pageSetup: { 
          paperSize: 9, // A4
          orientation: 'landscape'
        }
      });

      // Get all columns (safe handling for empty datasets)
      const columns = records.reduce((acc, record) => {
        Object.keys(flattenObject(record)).forEach(key => acc.add(key));
        return acc;
      }, new Set());

      // Add headers with styling
      const headerRow = worksheet.addRow(Array.from(columns));
      headerRow.font = { bold: true, color: { argb: 'FFFFFFFF' } };
      headerRow.fill = {
        type: 'pattern',
        pattern: 'solid',
        fgColor: { argb: 'FF0070C0' }
      };
      headerRow.border = {
        top: { style: 'thin' },
        left: { style: 'thin' },
        bottom: { style: 'thin' },
        right: { style: 'thin' }
      };

      // Add data rows with proper value handling
      records.forEach(record => {
        const flatRecord = flattenObject(record);
        const rowValues = Array.from(columns).map(col => {
          const value = flatRecord[col];
          
          // Convert special values for Excel compatibility
          if (value === null || value === undefined) return '';
          if (value instanceof Date) return value;
          if (typeof value === 'object') return JSON.stringify(value);
          
          return value;
        });
        
        const row = worksheet.addRow(rowValues);
        
        // Add light zebra striping
        if (row.number % 2 === 0) {
          row.fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: 'FFF2F2F2' }
          };
        }
      });

      // Auto-size columns with limits
      worksheet.columns.forEach(column => {
        let maxLength = 0;
        column.eachCell({ includeEmpty: true }, cell => {
          try {
            const cellValue = cell.value ? cell.value.toString() : '';
            maxLength = Math.max(maxLength, cellValue.length);
          } catch (e) {
            console.warn('Error measuring cell width:', e);
          }
        });
        
        // Set column width with reasonable limits
        column.width = Math.min(Math.max(maxLength + 2, 10), 50);
        
        // Format columns based on content
        if (column.values.some(v => v instanceof Date)) {
          column.numFmt = 'yyyy-mm-dd hh:mm:ss';
        }
      });

      // Freeze header row
      worksheet.views = [
        { state: 'frozen', xSplit: 0, ySplit: 1 }
      ];
    }
  }

  // Write file with robust settings
  try {
    await workbook.xlsx.writeFile(filePath, {
      useStyles: true,
      useSharedStrings: true
    });
    
    // Verify file was created properly
    if (!fs.existsSync(filePath) || fs.statSync(filePath).size === 0) {
      throw new Error('Failed to create valid Excel file');
    }
    
    return filePath;
  } catch (error) {
    // Clean up potentially corrupted file
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
    }
    throw error;
  }
};

// Improved flattening function with circular reference protection
function flattenObject(obj, prefix = '', seen = new WeakSet()) {
  if (typeof obj === 'object' && obj !== null) {
    if (seen.has(obj)) {
      return '[Circular]';
    }
    seen.add(obj);
  }

  return Object.keys(obj).reduce((acc, key) => {
    const prefixedKey = prefix ? `${prefix}.${key}` : key;
    if (typeof obj[key] === 'object' && obj[key] !== null && !Array.isArray(obj[key])) {
      Object.assign(acc, flattenObject(obj[key], prefixedKey, seen));
    } else {
      // Handle special cases for Excel
      if (obj[key] === null) {
        acc[prefixedKey] = '';
      } else if (obj[key] === undefined) {
        acc[prefixedKey] = '';
      } else {
        acc[prefixedKey] = obj[key];
      }
    }
    return acc;
  }, {});
}

module.exports = { createExcelFile };