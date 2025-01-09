// controllers/bookController.js
const path = require('path');
const fs = require("fs");
const { book } = require('../models');
const { Worker } = require("worker_threads");
const crypto = require('crypto');

const { uploadFields  } = require('../utils/multerConfig');
const {extractBookDetails,extractDisplayImage }= require('../utils/imageExtractor'); 


exports.uploadFile =[
  uploadFields,
  async (req, res) => {
    try {

        if (!req.files || !req.files['file']) {
            return res.status(400).json({ message: "No file uploaded." });
        }
        const file = req.files['file'][0];
        const tempFilePath = file.path; 
        const bookDetails = await extractBookDetails(tempFilePath);
        if (!bookDetails) {
            return res.status(400).json({ message: "Unable to extract book details." });
        }
        const hash = crypto.createHash('sha256').update(
            `${bookDetails.title}-${bookDetails.author}-${bookDetails.totalPages}-${bookDetails.edition}`
        ).digest('hex').substring(0, 10); 

        const fileExtension = path.extname(tempFilePath);
        const fileName = `${bookDetails.title}-${hash}${fileExtension}`;
        const finalFilePath = path.join(__dirname, '../storage/library', req.body.category, 'books', fileName);
        const displayImagePath= path.join(__dirname, '../storage/library', req.body.category, 'photos', `${bookDetails.title}-${hash}-01.jpg`);
        const existingBook = await book.findOne({ where: { file_path: finalFilePath } });


        if (existingBook) {
            fs.unlinkSync(tempFilePath);
            return res.status(400).json({ message: "Duplicate book detected." });
        }
        

        const newBook = await book.create({
            title: bookDetails.title || path.parse(file.originalname).name,
            category: req.body.category,
            subject_id:req.body.subject_id,
            added_by : req.user.user_id,
            file_path: finalFilePath,
            author: bookDetails.author,
            edition: bookDetails.edition,
            numberOfPages: bookDetails.totalPages,
            file_size: bookDetails.file_size
        });

        const directory = path.dirname(finalFilePath);
        if (!fs.existsSync(directory)) {
            fs.mkdirSync(directory, { recursive: true });
        }
        fs.renameSync(tempFilePath, finalFilePath);

        await extractDisplayImage(finalFilePath, displayImagePath);
        newBook.display_image=displayImagePath;
        await newBook.save();

        return res.status(201).json({
            message: "Book created successfully.",
            book: newBook
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: "Internal server error.", error: error.message });
    }
  }
];

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

        // await fs.promises.unlink(path.resolve(Book.file_path));
        // await fs.promises.unlink(path.resolve(Book.display_image));
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














//  for storage 
//  const >> from  path of hostage to file of local storage 
//  var   >> depends on each path of (image,....file path)
// file_path when you storing books ,storing it as uniqe in local storage 
// and display_image path >> extract from pdf file of book ( bit map )  first time download the displaye_image and storage
// inside  storage 3 files for all category 
// download and >> upload (streeming) with create (threading) [download on backgraund dont stop app] 
// CRUD  >>  CREATE with upload,    Get the only data with filter by category, 
// 
// 
// 
// const BASE_URL = process.env.BASE_URL;
// const UPLOAD_DIR = process.env.UPLOAD_DIR;
// const uniqueName = `${Date.now()}_${file.originalname}`;
// const fileUrl = `${BASE_URL}/${category}/${uniqueName}`;
