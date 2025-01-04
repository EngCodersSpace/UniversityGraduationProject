// hooks/bookhooks.js

const getStoragePaths = require('../utils/filePaths');
const extractDisplayImage = require('../utils/imageExtractor');

const bookHooks = {
  beforeCreate: async (bookInstance) => {
    const { category, id, title } = bookInstance;

    // Generate storage paths dynamically
    const { filePath, displayImagePath } = getStoragePaths(category, id, title);

    // Assign file paths to the instance
    bookInstance.file_path = filePath;
    bookInstance.display_image = displayImagePath;

    // Extract the display image
    await extractDisplayImage(filePath, displayImagePath);
  },
};

module.exports = bookHooks;