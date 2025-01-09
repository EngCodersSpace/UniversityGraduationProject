// hooks/bookhooks.js
const getStoragePaths = require('../utils/filePaths');
const { extractDisplayImage,extractBookDetails }= require('../utils/imageExtractor');
const fs = require("fs");
const path=require('path')

const bookHooks = {
  afterCreate: async (bookInstance) => {
    // const { file_path ,title,category} = bookInstance;
    // console.log('\n \n category :', bookInstance.category ,'\n \n title', bookInstance.title);
    // const { displayImagePath } = getStoragePaths(category , title);
    // bookInstance.file_path = filePath;

    // const displayImagePath= path.join(__dirname, '../storage/library', category, 'photos', `${title}.jpg`);
    // bookInstance.display_image = displayImagePath;
    // console.log('\n \n file_path of book :',  filePath);
    // console.log('\n \n display_image of book delete:', displayImagePath );

    try {
      // const directory = filePath.substring(0, filePath.lastIndexOf("\\"));
      // if (!fs.existsSync(directory)) {
      //   fs.mkdirSync(directory, { recursive: true });
      //   console.log('Created directory:', directory);
      // }
      // await extractDisplayImage(file_path, displayImagePath);
      // const bookDetails = await extractBookDetails(filePath);
      // bookInstance.title = bookDetails.title;
      // console.log('\n \n Title from extractBookDetails', bookInstance.title);
      // bookInstance.author = bookDetails.author ;
      // bookInstance.edition = bookDetails.edition ;
      // bookInstance.numberOfPages = bookDetails.totalPages ;
      // bookInstance.file_size = parseFloat(bookDetails.file_size) ;
      // console.log('\n \n Updated book instance with additional details:', {
      //   title:bookInstance.title,
      //   author: bookInstance.author,
      //   edition: bookInstance.edition,
      //   file_size: bookInstance.file_size,
      //   numberOfPages:bookInstance.numberOfPages,
      // });
      // await bookInstance.save();
    } catch (error) {
      console.error('Error in afterCreate hook:', error.message, '\n \n Stack Trace:\n ', error.stack);
      throw error;
    }
  },


};
module.exports = bookHooks;