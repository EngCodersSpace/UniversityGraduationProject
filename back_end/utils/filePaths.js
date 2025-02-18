// utils/filePaths.js
const path = require('path');
function getStoragePaths(category, title) {
  // const filePath = path.resolve(__dirname, '../storage/library', category , 'books', `${title}.pdf`);
  const displayImagePath = path.resolve(__dirname, '../storage/library' , category ,'photos', `${path.parse(title).name}.jpg`);
  // console.log('\n \n inside utils/filePaths.js >> filePath:', filePath);
  console.log('\n \n inside utils/filePaths.js >> displayImagePath:', displayImagePath);
  return { displayImagePath };
}
module.exports = getStoragePaths;