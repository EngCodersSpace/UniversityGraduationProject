// utils/filePaths.js
const path = require('path');

function getStoragePaths(category, id, title) {
  const basePath = path.join(__dirname, '../storage/library');
  const categoryPath = path.join(basePath, category);

  const filePath = path.join(categoryPath, `${id}_${title}.pdf`);
  const displayImagePath = path.join(categoryPath, `${id}_${title}_display.jpg`);

  return { filePath, displayImagePath };
}

module.exports = getStoragePaths;


