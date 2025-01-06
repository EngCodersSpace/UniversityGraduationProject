// hooks/bookhooks.js
const getStoragePaths = require('../utils/filePaths');
const extractDisplayImage = require('../utils/imageExtractor');
const fs = require("fs");


const bookHooks = {
  afterCreate: async (bookInstance) => {
    const { category ,title} = bookInstance;
    console.log('\n \n category :', bookInstance.category ,'\n \n title', bookInstance.title);
    const { filePath , displayImagePath } = getStoragePaths(category , title);
    bookInstance.file_path = filePath;
    bookInstance.display_image = displayImagePath;
    console.log('\n \n file_path of book :',  filePath);
    console.log('\n \n display_image of book :', displayImagePath );

    try {
      const directory = filePath.substring(0, filePath.lastIndexOf("\\"));
      if (!fs.existsSync(directory)) {
        fs.mkdirSync(directory, { recursive: true });
        console.log('Created directory:', directory);
      }
      await extractDisplayImage(filePath, displayImagePath);
      await bookInstance.save();
    } catch (error) {
      console.error('Error in afterCreate hook:', error.message, '\n \n Stack Trace:\n ', error.stack);
      throw error;
    }
  },
};

module.exports = bookHooks;