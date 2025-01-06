// utils/filePaths.js
const path = require('path');

function getStoragePaths(category,title) {
  const basePath = process.env.UPLOAD_PATH || path.join(__dirname, '../storage/library');
  const categoryPath = path.join(basePath, category);

  const filePath =  path.join(categoryPath, `${title}.pdf`);
  const displayImagePath = path.join(categoryPath, `${path.parse(title).name}`); 

  console.log('\n \n inside utils/filePaths.js >> filePath:', filePath);
  console.log('\n \n inside utils/filePaths.js >> displayImagePath:', displayImagePath);

  return { filePath, displayImagePath };
}
module.exports = getStoragePaths;