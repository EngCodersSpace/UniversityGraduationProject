// utils/imageExtractor.js

// const { convertFromPath } = require('pdf2image');
// const fs = require('fs');

// async function extractDisplayImage(pdfPath, outputPath) {
//   try {
//     const images = await convertFromPath(pdfPath, { dpi: 300 });
//     await images[0].save(outputPath, 'JPEG');
//   } catch (error) {
//     console.error('Error extracting display image:', error);
//     throw error;
//   }
// }

// module.exports = extractDisplayImage;

// utils/imageExtractor.js


// utils/imageExtractor.js

const fs = require('fs');
const path = require('path');
const pdfPoppler = require('pdf-poppler');
const { PDFDocument } = require('pdf-lib');

/**
 * Extract the first page of a PDF and save it as an image.
 * @param {string} pdfPath - Path to the PDF file.
 * @param {string} outputPath - Path to save the output image.
 */
async function extractDisplayImage(pdfPath, outputPath) {
  try {
    const outputDir = path.dirname(outputPath);

    const options = {
      format: 'jpg', // Output format (e.g., png or jpeg)
      out_dir: outputDir, // Directory to save the image
      out_prefix: path.basename(pdfPath, '.pdf'), // Image file prefix
      page: 1 // Extract only the first page
    };

    await pdfPoppler.convert(pdfPath, options);

    const finalImageName = `${path.basename(pdfPath, '.pdf')}.${options.format}`;
    const generatedImagePath = path.join(outputDir, finalImageName);

    // إعادة تسمية الصورة الناتجة إلى الاسم النهائي
    const generatedImageFiles = fs.readdirSync(outputDir).filter(file => file.startsWith(options.out_prefix));
    if (generatedImageFiles.length > 0) {
      const tempImagePath = path.join(outputDir, generatedImageFiles[0]);
      await fs.promises.rename(tempImagePath, generatedImagePath);
    }


    // const generatedImagePath = path.join(outputDir,`${options.out_prefix}.${options.format}`);

    console.log(`\n \n outputPath: ${outputPath}`); // ..\storage\library\Lecture\photos\Data_Structure.jpg
    console.log(`\n \n options.out_prefix: ${options.out_prefix}`);  // Data_Structure
    console.log(`\n \n options.format: ${options.format}`);          // jpeg
    console.log(`\n \n First page saved as an image at: ${generatedImagePath}`); // ..\storage\library\Lecture\photos\Data_Structure.jpeg

    return generatedImagePath; 

  } catch (error) {
    console.error('Error extracting display image:', error.message);
    throw error;
  }
}

/**
 * Extract metadata and additional details from a PDF file.
 * @param {string} filePath - Path to the PDF file.
 * @returns {Promise<Object>} - Object containing metadata and additional details.
 */
async function extractBookDetails(filePath) {
  try {
    // Read the file
    const fileBuffer = fs.readFileSync(filePath);

    // Load file data using pdf-lib
    const pdfDoc = await PDFDocument.load(fileBuffer);

    // Extract metadata
    const metadata = {
      title: pdfDoc.getTitle() || path.basename(filePath, '.pdf'),
      author: pdfDoc.getAuthor() || 'Unknown',
      subject: pdfDoc.getSubject() || 'Unknown',
      keywords: pdfDoc.getKeywords() || [],
      creationDate: pdfDoc.getCreationDate() || null,
      modificationDate: pdfDoc.getModificationDate() || null,
      producer: pdfDoc.getProducer() || 'Unknown',
      totalPages :pdfDoc.getPageCount() || 0,
    };

    // Calculate file size (in MB)
    const fileSizeInBytes = fs.statSync(filePath).size;
    const fileSizeInMB = (fileSizeInBytes / (1024 * 1024)).toFixed(2);

    // Additional details (can be customized manually or fetched from a database)
    const additionalDetails = {
      edition: 'Unknown',
      file_size: fileSizeInMB, 
    };

    // Merge metadata and additional details
    const bookDetails = { ...metadata, ...additionalDetails };

    console.log(bookDetails);
    return bookDetails;
  } catch (error) {
    console.error('Error extracting book details:', error.message);
    throw error;
  }
}

module.exports = {
  extractDisplayImage,
  extractBookDetails,
};
