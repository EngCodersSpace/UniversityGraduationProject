const { convertFromPath } = require('pdf2image');
const fs = require('fs');

async function extractDisplayImage(pdfPath, outputPath) {
  try {
    const images = await convertFromPath(pdfPath, { dpi: 300 });
    await images[0].save(outputPath, 'JPEG');
  } catch (error) {
    console.error('Error extracting display image:', error);
    throw error;
  }
}

module.exports = extractDisplayImage;
