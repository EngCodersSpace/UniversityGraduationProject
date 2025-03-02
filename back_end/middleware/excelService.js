const xlsx = require('xlsx');

const readExcelFile = (filePath) => {
  const workbook = xlsx.readFile(filePath);
  const sheetsData = {};

  workbook.SheetNames.forEach((sheetName) => {
    const sheet = workbook.Sheets[sheetName];
    sheetsData[sheetName] = xlsx.utils.sheet_to_json(sheet);
  });

  return sheetsData;
};






module.exports = { readExcelFile };