// controllers/bookController.js
const path = require('path');
const fs = require("fs");
const { book,student_assignment,student_assignment_file} = require('../models');
const { Worker } = require("worker_threads");
const crypto = require('crypto');

const { uploadFields  } = require('../utils/multerConfig');
const {extractBookDetails,extractDisplayImage }= require('../utils/imageExtractor'); 


exports.uploadFile = async (req, res) => {
  try {
    uploadFields(`library/${req.body.category}`,'books').single('file')(req, res, async (err) => {
      if (err) {
        return res.status(400).json({ message: 'File upload failed', error: err.message });
      }
      if (!req.file) {
        return res.status(400).json({ message: 'No file provided for upload.' });
      }
      const bookDetails = await extractBookDetails(file.path);
      const hash = crypto.createHash('md5').update(
        `${bookDetails.title}-${bookDetails.author}-${bookDetails.totalPages}-${bookDetails.edition}`
      ).digest('hex');

      const fileName = `${hash}${path.extname(file.path)}`;
      const finalFilePath = path.join(__dirname, '../storage/library', req.body.category, 'books', fileName);
      const displayImagePath = path.join(__dirname, '../storage/library', req.body.category, 'photos', `${hash}.jpg`);

      const existingBook = await book.findOne({ where: { file_path: finalFilePath } });
      if (existingBook) {
        fs.unlinkSync(file.path); 
      }


      const newBook = await book.create({
        title: bookDetails.title || path.parse(file.originalname).name,
        category: req.body.category,
        subject_id: req.body.subject_id,
        added_by: req.user.user_id,
        file_path: finalFilePath,
        author: bookDetails.author,
        edition: bookDetails.edition,
        numberOfPages: bookDetails.totalPages,
        file_size: bookDetails.file_size,
      });

      const directory = path.dirname(finalFilePath);
      if (!fs.existsSync(directory)) {
        fs.mkdirSync(directory, { recursive: true });
      }
      await extractDisplayImage(finalFilePath, displayImagePath);
      newBook.display_image = displayImagePath;
      await newBook.save();

      return res.status(201).json({
        message: "Books uploaded successfully.",
        books: uploadedBooks,
      });
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Internal server error.", error: error.message });
  }
};  

exports.uploadFilesAttachment = async (req, res) => {
  try {
    uploadFields('assignments/students', `${req.body.section_id}/${req.body.level_id}`).single('file')(req, res, async (err) => {
      if (err) {
        return res.status(400).json({ message: 'Error during file upload.', error: err.message });
      }

      if (!req.file) {
        return res.status(400).json({ message: 'No file provided for upload.' });
      }
      const studentAssignment = await student_assignment.findOne({
        where: {
          student_id: req.user.user_id,
          assignment_id: req.body.assignment_id,
        },
      });

      const newFile = await student_assignment_file.create({
        student_assignment_id: studentAssignment.id,
        attachment: req.file.path,
        attachment_hash: req.file.hash,
      });

      res.status(201).json({
        message: 'File uploaded successfully.',
        file: {
          id: newFile.id,
          student_assignment_id:newFile.student_assignment_id,
          path: newFile.attachment,
          hash: newFile.attachment_hash,
        },
      });
    });

    
  } catch (error) {
    console.error('Error while uploading file:', error.message);
    res.status(500).json({ message: 'Internal server error.', error: error.message });
  }

};

exports.downloadFile = async (req, res) => {
  try {
    const fileData = await book.findByPk(req.query.id);
    if (!fileData) {
      return res.status(404).json({ message: "File not found in database." });
    }
    const filePath= fileData.file_path;
    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ message: "File not found on server." });
    }

    // start download using worker_threads 
    const worker = new Worker(path.join(__dirname, "../utils/downloadWorker.js"), {
      workerData: { filePath },
    });
    console.log(`\n \n worker find path ${filePath} \n \n` );
    worker.on("message", (message) => {
      if (message.status === "success") {
        console.log(`\n \n \nDownload started in the background.${message.status} \n ${message.filePath}\n \n` );
        // res.status(200).json({ message: "Download started in the background.", path: message.filePath });
      }
    });
    worker.on("error", (err) => {
      console.log(`\n \n \n Error occurred during the download process.${err.message} \n \n \n `);
      // res.status(500).json({ message: "Error occurred during the download process.", error: err.message });
    });
    
    res.status(200).json({ message: "Download started in the background." });
  } catch (error) {
    console.error("Error during download:", error);
    res.status(500).json({ message: "Failed to start download.", error: error.message });
  }
};

exports.getBooksByCategory = async (req, res) => {
  try {

      if (!req.query.category) {
          return res.status(400).json({message: "Category is required" });
      }

      const books = await book.findAll({
          where: { category: req.query.category },
      });

      if (books.length === 0) {
          return res.status(404).json({ success: false, message: "No books found for the specified category" });
      }

      res.status(200).json({ message: `get all books depends on category:${ (  req.query.category )} succssfully `, data: books });
  } catch (error) {
      console.error("Error fetching books by category:", error);
      res.status(500).json({message: "An error occurred while fetching books", error: error.message });
  }
};

exports.deleteBook = async (req, res) => {
  try {
    const Book = await book.findByPk(req.query.id);
    if (!Book) {
        return { success: false, message: "Book not found" };
    }
    const filePath = path.resolve(Book.file_path);
    const imagePath = path.resolve(Book.display_image);
    if (fs.existsSync(filePath)) {
        await fs.promises.unlink(filePath);
        console.log(`Deleted file: ${filePath}`);
    } else {
        console.warn(`\n \n \n File not found: ${filePath}`);
    }
    if (fs.existsSync(imagePath)) {
        await fs.promises.unlink(imagePath);
        console.log(`Deleted image: ${imagePath}`);
    } else {
        console.warn(`\n \n \n Image not found: ${imagePath}`);
    }
    await book.destroy({ where: { id:req.query.id } });
    res.status(200).json({ message: "Book and its related files were deleted successfully" });
  } catch (error) {
        console.error("Error deleting book:", error);
        res.status(500).json({ message: "An error occurred while deleting the book" ,error: error.message});
  }
};

