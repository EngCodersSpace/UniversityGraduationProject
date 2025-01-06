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

/**
 * Extract the first page of a PDF and save it as an image.
 * @param {string} pdfPath - Path to the PDF file.
 * @param {string} outputPath - Path to save the output image.
 */
async function extractDisplayImage(pdfPath, outputPath) {
  try {
    // Ensure output directory exists
    const outputDir = path.dirname(outputPath);
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    // Configure options for pdf-poppler
    const options = {
      format: 'png', // Output format (e.g., png or jpeg)
      out_dir: outputDir, // Directory to save the image
      out_prefix: path.basename(pdfPath, '.pdf'), // Image file prefix
      page: 1 // Extract only the first page
    };

    // Use pdf-poppler to convert the first page of the PDF to an image
    await pdfPoppler.convert(pdfPath, options);

    const generatedImagePath = path.join(
      outputDir,
      `${options.out_prefix}-1.${options.format}`
    );
    console.log(`First page saved as an image at: ${generatedImagePath}`);

    return generatedImagePath; 
  } catch (error) {
    console.error('Error extracting display image:', error.message);
    throw error;
  }
}


module.exports = extractDisplayImage;