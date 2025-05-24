// documentHandler.js
const fs = require('fs');
const path = require('path');
const { PDFDocument } = require('pdf-lib');
const pdfPoppler = require('pdf-poppler');
const mammoth = require('mammoth');
const { fromPath } = require('pdf2pic');
const { Document, Packer } = require('docx');

async function extractDisplayImage(filePath, outputImagePath) {
  const ext = path.extname(filePath).toLowerCase();
  const outputDir = path.dirname(outputImagePath);
  if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });

  if (ext === '.pdf') {
    const options = {
      format: "png",
      out_dir: outputDir,
      out_prefix: path.basename(filePath, ".pdf"),
      page: 1,
    };
    await pdfPoppler.convert(filePath, options);
    const generatedImageFiles = fs
      .readdirSync(outputDir)
      .filter((file) => file.startsWith(options.out_prefix));

    if (generatedImageFiles.length > 0) {
      const tempImagePath = path.join(outputDir, generatedImageFiles[0]);
      const finalImagePath = path.join(outputDir, `${options.out_prefix}.${options.format}`);
      await fs.promises.rename(tempImagePath, finalImagePath);
      return finalImagePath;
    } else {
      throw new Error("No image file was generated.");
    }
  } else {
    console.warn(`No image extraction implemented for file type: ${ext}`);
    return null;
  }
}

async function extractDocumentDetails(filePath) {
  const ext = path.extname(filePath).toLowerCase();
  let details = {};

  try {
    const fileSizeInBytes = fs.statSync(filePath).size;
    const fileSizeInMB = parseFloat((fileSizeInBytes / (1024 * 1024)).toFixed(2));

    if (ext === '.pdf') {
      const fileBuffer = fs.readFileSync(filePath);
      const pdfDoc = await PDFDocument.load(fileBuffer);
      details = {
        type: 'PDF',
        title: pdfDoc.getTitle() || path.basename(filePath, '.pdf'),
        author: pdfDoc.getAuthor() || 'Unknown',
        subject: pdfDoc.getSubject() || 'Unknown',
        keywords: pdfDoc.getKeywords() || [],
        creationDate: pdfDoc.getCreationDate() || null,
        modificationDate: pdfDoc.getModificationDate() || null,
        producer: pdfDoc.getProducer() || 'Unknown',
        totalPages: pdfDoc.getPageCount() || 0,
      };
    } else if (ext === '.docx') {
      const result = await mammoth.extractRawText({ path: filePath });
      details = {
        type: 'Word',
        title: path.basename(filePath, '.docx'),
        author: 'Unknown',
        contentPreview: result.value.slice(0, 300),
      };
    } else if (ext === '.txt') {
      const content = fs.readFileSync(filePath, 'utf8');
      details = {
        type: 'Text',
        title: path.basename(filePath),
        contentPreview: content.slice(0, 300),
      };
    } else {
      details = {
        type: 'Unknown',
        title: path.basename(filePath),
        info: 'Unsupported file type',
      };
    }

    return { ...details, file_size: fileSizeInMB };
  } catch (error) {
    console.error(`Error extracting details: ${error.message}`);
    throw error;
  }
}

module.exports = {
  extractDisplayImage,
  extractDocumentDetails,
};