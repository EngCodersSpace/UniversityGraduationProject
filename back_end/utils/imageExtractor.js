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
const { PDFDocument } = require('pdf-lib');
const sharp = require('sharp');

/**
 * Extract the first page of a PDF and save it as an image.
 * @param {string} pdfPath - Path to the PDF file.
 * @param {string} outputPath - Path to save the output image.
 */
async function extractDisplayImage(pdfPath, outputPath) {
  try {
    // Load the PDF file
    const pdfBytes = fs.readFileSync(pdfPath);
    const pdfDoc = await PDFDocument.load(pdfBytes);

    // Get the first page
    const firstPage = pdfDoc.getPage(0);

    // Get page dimensions
    const { width, height } = firstPage.getSize();

    // Render the page to an image
    const pageImage = await firstPage.render({
      scale: 1.0, // Adjust scale if needed
    });

    // Convert the page image to PNG using sharp
    const imageBuffer = Buffer.from(pageImage.data);
    await sharp(imageBuffer, {
      raw: {
        width: pageImage.width,
        height: pageImage.height,
        channels: 4, // RGBA
      },
    })
      .png()
      .toFile(outputPath);

    console.log(`First page saved as an image at: ${outputPath}`);
  } catch (error) {
    console.error('Error extracting first page as image:', error);
  }
}

module.exports = extractDisplayImage;