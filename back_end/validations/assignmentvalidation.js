const crypto = require('crypto');
const { assignment, assignment_file } = require('../models'); // Import models

const validateAndUploadFiles = async (req, res, next) => {
  if (!req.query.assignment_id) {
    return res.status(400).json({ message: 'Assignment ID is required.' });
  }

  const assignmentExists = await assignment.findByPk(req.query.assignment_id);
  if (!assignmentExists) {
    return res.status(404).json({ message: 'Assignment not found.' });
  }

  const duplicateFiles = [];
  const newFiles = [];

  for (const file of req.files) { 
    const hash = crypto.createHash('md5').update(file.originalname + file.size).digest('hex');

    const existingFile = await assignment_file.findOne({
      where: {
        assignment_id: req.query.assignment_id,
        attachment_hash: hash,
      },
    });

    if (existingFile) {
      duplicateFiles.push(file.originalname);
    } else {
      // Mark the file as new and add to the newFiles array
      newFiles.push({
        originalName: file.originalname,
        mimeType: file.mimetype,
        size: file.size,
        hash,
      });
    }
  }

  // If there are new files, save them to the database or storage
  if (newFiles.length > 0) {
    for (const newFile of newFiles) {
      await assignment_file.create({
        assignment_id: req.query.assignment_id,
        attachment_hash: newFile.hash,
        original_name: newFile.originalName,
        mime_type: newFile.mimeType,
        size: newFile.size,
      });
    }
  }

  // Respond with a summary of the operation
  return res.status(200).json({
    message: 'File processing completed.',
    duplicates: duplicateFiles,
    newFiles: newFiles.map((file) => file.originalName),
  });
};

module.exports = validateAndUploadFiles;
