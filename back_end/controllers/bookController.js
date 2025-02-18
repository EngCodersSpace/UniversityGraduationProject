// controllers/bookController.js
const path = require('path');
const fs = require("fs");
const { book,section,level} = require('../models');
const { Worker } = require("worker_threads");
const crypto = require('crypto');
const { uploadFields ,createFolderIfNotExists } = require('../utils/multerConfig');
const {extractBookDetails,extractDisplayImage }= require('../utils/imageExtractor'); 
const { upsertRefreshState} = require('../controllers/refreshController');
const { Op } = require('sequelize'); 

// To check if a file is a duplicate
exports.checkFileDuplicate = async (req, res) => {
  try {
    const hash = crypto.createHash('md5').update(req.body.originalname + req.body.size).digest('hex');
    const existingFile = await book.findOne({
      where: {
        file_path: { [Op.like]: `%${hash}%` }, 
        section_id: req.body.section_id, 
        level_id: req.body.level_id, 
      },
    });

    if (existingFile) {
      return res.status(400).json({ message: 'Sorry, this file has already been uploaded.' });
    } else {
      return res.status(200).json({ message: 'File is ready to be uploaded successfully.' });
    }
  } catch (error) {
    console.error('Error while checking file duplicates:', error.message);
    res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};

exports.uploadFile = async (req, res) => {
  try {
    const sectionData = await section.findOne({ where: { id: req.query.section_id } });
    const levelData = await level.findOne({ where: { id: req.query.level_id } });
    if (!sectionData || !levelData) {
      throw new Error("Section or Level not found with the provided IDs.");
    }
    const sectionNameObj = JSON.parse(sectionData.section_name); 
    const sectionNameEN = sectionNameObj.en; 
    const levelName = levelData.level_name;

    const folder = `library/${req.query.category}/${sectionNameEN}/${levelName}`;
    const subfolder=`books`;
    uploadFields(folder,subfolder).single('file')(req, res, async (err) => {
      if (err) {
        return res.status(400).json({ message: 'File upload failed', error: err.message });
      }
      if (!req.file) {
        return res.status(400).json({ message: 'No file provided for upload.' });
      }

      const filepath=path.join('storage',req.file.path);
      console.log('\n \n filepath=',filepath  , '\n \n ');

      const bookDetails = await extractBookDetails(filepath);

      try {
        const displayImagePath = path.join( 'storage/library', `${req.query.category}/${sectionNameEN}/${levelName}`,'photos', `${req.file.hash}.png`);

        const newBook = await book.create({
          title: bookDetails.title || req.file.originalName,
          category: req.query.category,
          subject_id: req.body.subject_id,
          added_by: req.user.user_id,
          section_id:req.query.section_id,
          level_id:req.query.level_id,
          original_name:req.file.originalName,
          file_path: filepath,
          author: bookDetails.author,
          edition: bookDetails.edition,
          numberOfPages: bookDetails.totalPages,
          file_size: bookDetails.file_size,
        });

        await createFolderIfNotExists(filepath);
        await extractDisplayImage(filepath, displayImagePath);
        
        newBook.display_image = displayImagePath;
        await newBook.save();
        await upsertRefreshState("book",`section_id : ${req.query.section_id} - level_id : ${req.query.level_id}`);


        return res.status(201).json({
          message: "Books uploaded successfully.",
          books: newBook,
        });
    
      } catch(error){
        res.status(500).json({
          message: 'Error inner uploadFile.',
          error: error.message,
        });
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: 'Error uploadFile.',
      error: error.message,
    });
  }
};  


exports.downloadFile = async (req, res) => {
  try {

    const fileData = await book.findByPk(req.query.id);
    if (!fileData) {
      return res.status(404).json({ message: "File not found in database." });
    }

    const filePath= path.resolve(__dirname,'..',`storage/${fileData.file_path}`);

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
    
    res.status(200).json({ message: "Download Finish " });
  } catch (error) {
    console.error("Error during download:", error);
    res.status(500).json({ message: "Failed to start download.", error: error.message });
  }
};

exports.downloadFile1 = async (req, res) => {
  try {

    const fileData = await book.findByPk(req.query.id);
    if (!fileData) {
      return res.status(404).json({ message: "File not found in database." });
    }

    const filePath= path.resolve(__dirname,'..',`${fileData.file_path}`);
    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ message: "File not found on server." });
    }

    // Stream the file directly
    res.download(filePath, (err) => {
      if (err) {
        if (!res.headersSent) {
          res.status(500).json({ message: "Download failed", error: err.message });
        }
      }
    });

  } catch (error) {
    console.error("Error during download:", error);
    res.status(500).json({ message: "Failed to start download.", error: error.message });
  }
};

exports.downloadFile2 = async (req, res) => {
  try {

    const fileData = await book.findByPk(req.query.id);
    if (!fileData) {
      return res.status(404).json({ message: "File not found in database." });
    }

    const filePath= path.resolve(__dirname,'..',`${fileData.file_path}`);
    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ message: "File not found on server." });
    }
    const stats = await fs.promises.stat(filePath);

    res.setHeader('Content-Disposition', 'attachment; filename="file.zip"');
    res.setHeader('Content-Type', 'application/zip');
    res.setHeader('Content-Length', stats.size);

    const stream = fs.createReadStream(filePath);
    stream.pipe(res);
    
    stream.on('error', (err) => {
      if (!res.headersSent) res.status(500).send('Error streaming file');
    });


  } catch (error) {
    console.error("Error during download:", error);
    res.status(500).json({ message: "Failed to start download.", error: error.message });
  }
};



// To get books by filtering (section, level, category) and stream them
exports.streamBooks = async (req, res) => {
  try {
    const { section_id, level_id, category } = req.query;

    // Build the where clause for filtering
    const whereClause = {};
    if (section_id) whereClause.section_id = section_id;
    if (level_id) whereClause.level_id = level_id;
    if (category) whereClause.category = category;

    // Fetch books from the database
    const books = await book.findAll({
      where: whereClause,
    });

    if (!books.length) {
      return res.status(404).json({ message: 'No books found for the specified criteria.' });
    }

    // Set headers for streaming JSON
    res.setHeader('Content-Type', 'application/json');
    res.setHeader('Transfer-Encoding', 'chunked');

    let index = 0;
    const chunkSize = 5; // Number of books per chunk

    res.write('['); // Start JSON array

    const interval = setInterval(() => {
      if (index >= books.length) {
        res.write(']'); // Close JSON array
        res.end();
        clearInterval(interval);
        return;
      }

      const chunk = books.slice(index, index + chunkSize);
      index += chunkSize;

      res.write(JSON.stringify(chunk)); // Send JSON chunk

      if (index < books.length) {
        res.write(','); // Add comma between chunks
      }
    }, 1000); // Send a chunk every second
  } catch (error) {
    console.error('Error streaming books:', error.message);
    res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};

//  get image from path by id (req.query.id)
exports.getImageOfBook = async (req, res) => {
  try {

      if (!req.query.id) {
          return res.status(400).json({message: "book id  is required" });
      }

      const ImageOfBook = await book.findOne({
          where: { id: req.query.id },
      });

      if (ImageOfBook.length === 0) {
        return res.status(204).json();
      }

      if (!ImageOfBook) {
          return res.status(404).json({ success: false, message: "No image found for the specified book" });
      }
      const imagePath = path.join(__dirname  , '..', ImageOfBook.display_image);
      res.sendFile(imagePath);
  } catch (error) {
      console.error("Error fetching book's image:", error);
      res.status(500).json({message: "An error occurred while fetching book's image", error: error.message });
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
    await upsertRefreshState("book",`section_id : ${Book.section_id} - level_id : ${Book.level_id}`);
    await book.destroy({ where: { id:req.query.id } });

    res.status(200).json({ message: "Book and its related files were deleted successfully" });
  } catch (error) {
        console.error("Error deleting book:", error);
        res.status(500).json({ message: "An error occurred while deleting the book" ,error: error.message});
  }
};