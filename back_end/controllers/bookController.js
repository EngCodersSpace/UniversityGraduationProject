// controllers/bookController.js
const path = require('path');
const fs = require("fs");
const { book,section,level,subject} = require('../models');
const crypto = require('crypto');
const { uploadFields ,createFolderIfNotExists } = require('../utils/multerConfig');
const {extractBookDetails,extractDisplayImage }= require('../utils/imageExtractor'); 
const { upsertRefreshState} = require('../controllers/refreshController');
const { Op } = require('sequelize'); 
const { promisify } = require('util');
const mkdirAsync = promisify(fs.mkdir);

// To check if a file is a duplicate
exports.checkFileDuplicate = async (req, res) => {
  try {
    const hash = crypto.createHash('md5').update(req.body.originalname + req.body.size).digest('hex');
    for (const group of req.body.sectionsAndLevels) {
      const existingFile = await book.findOne({
      where: {
        file_path: { [Op.like]: `%${hash}%` }, 
        section_id: group["section_id"], 
        level_id: group["level_id"], 
      },
    });

    if (existingFile) {
      return res.status(400).json({ message: 'Sorry, this file has already been uploaded.' });
    }
    }

  
      return res.status(200).json({ message: 'File is ready to be uploaded successfully.' });
    
  } catch (error) {
    console.error('Error while checking file duplicates:', error.message);
    res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};

exports.uploadFile = async (req, res) => {
  try {
    if (!req.query.category) {
      return res.status(400).json({ message: 'Category is required' });
    }
  

    // Process file upload
    uploadFields( `library/${req.query.category}`, 'books').single('file')(req, res, async (err) => {
      if (err) return res.status(400).json({ message: 'Upload failed', error: err.message });
      if (!req.file) return res.status(400).json({ message: 'No file provided' });
      try {
        const filepath = path.join('storage', req.file.path);
        const bookDetails = await extractBookDetails(filepath);

        // Create display image only once
        const displayImagePath = path.join('storage', `library/${req.query.category}/photos`, `${req.file.hash}.png`);
        await mkdirAsync(path.dirname(displayImagePath), { recursive: true });
        
        // Only extract image if it doesn't exist yet
        try {
          await fs.promises.access(displayImagePath);
          console.log('Display image already exists, skipping extraction');
        } catch {
          await extractDisplayImage(filepath, displayImagePath);
        }
      
        const createdBooks = [];
        console.log("\n",req.query,"  ________________\n");
        const sectionsAndLevels = JSON.parse( req.query.sectionsAndLevels);
        for (const group of sectionsAndLevels) {
          console.log("\n",group,"  ________________\n");
          try {
            const newBook = await book.create({
              title: req.file.originalname,
              category: req.query.category,
              subject_id: req.query.subject_id || null,
              added_by: req.user.user_id,
              section_id: group["section_id"],
              level_id: group["level_id"],
              original_name: req.file.originalname,
              file_path: req.file.path,
              author: bookDetails.author,
              edition: bookDetails.edition,
              numberOfPages: bookDetails.totalPages,
              file_size: bookDetails.file_size,
              display_image: displayImagePath,

            });
            createdBooks.push(newBook);
          } catch (error) {
            console.error(`Failed to create book record for section ${group["section_id"]}, level ${group["level_id"]}:`, error);
          }
        }

        if (createdBooks.length === 0) {
          return res.status(500).json({ message: 'Failed to create any book records' });
        }

        // Refresh states for affected sections/levels
        const refreshPromises = [];
        const processedCombinations = new Set();
        
        for (const book of createdBooks) {
          const comboKey = `${book.section_id}-${book.level_id}`;
          if (!processedCombinations.has(comboKey)) {
            refreshPromises.push(upsertRefreshState("book", `section_id:${book.section_id}-level_id:${book.level_id}`));
            processedCombinations.add(comboKey);
          }
        }
        
        await Promise.all(refreshPromises);

        res.status(201).json({
          message: `Book uploaded successfully to ${createdBooks.length} combinations`,
          file_info: {
            path: req.file.path,
            size: req.file.size,
            hash: req.file.hash
          },
          books: createdBooks
        });

      } catch (error) {
        console.error('Book processing error:', error);
        res.status(500).json({ 
          message: 'Error processing book', 
          error: error.message,
          stack: process.env.NODE_ENV === 'development' ? error.stack : undefined
        });
      }
    });

  } catch (error) {
    console.error('Upload error:', error);
    res.status(500).json({ 
      message: 'Server error during upload setup', 
      error: error.message,
      stack: process.env.NODE_ENV === 'development' ? error.stack : undefined
    });
  }
};


exports.downloadFile = async (req, res) => {
  try {
    const fileData = await book.findByPk(req.query.id);
    if (!fileData) {
      return res.status(404).json({ error: "File not found" });
    }

    const filePath = path.resolve(__dirname, '..', `storage/${fileData.file_path}`);
    const fileSize = fs.statSync(filePath).size;

    // Set headers to instruct the browser to download the file
    res.setHeader('Content-Disposition', `attachment; filename="${path.basename(filePath)}"`);
    res.setHeader('Content-Type', 'application/octet-stream');
    res.setHeader('Content-Length', fileSize);


    // Create a read stream and pipe it directly to the response
    const readStream = fs.createReadStream(filePath);
    readStream.pipe(res);

    readStream.on('error', (err) => {
      console.error("Error during streaming:", err);
      res.status(500).end('Error reading file.');
    });
    
  } catch (error) {
    console.error("Error during download:", error);
    res.status(500).json({ 
      error: "Download failed",
      details: error.message 
    });
  }
};

// To get books by filtering (section, level, category) and stream them
exports.streamBooks = async (req, res) => {
  try {
    const { section_id, level_id, category } = req.query;

    // Build the where clause dynamically
    const whereClause = {};
    if (section_id) whereClause.section_id = section_id;
    if (level_id) whereClause.level_id = level_id;
    if (category) whereClause.category = category;

    // Fetch books from the database
    const books = await book.findAll({ where: whereClause });

    if (!books.length) {
      return res.status(204).json({ message: 'No books found for the specified criteria.' });
    }

    // Set headers for streaming JSON
    res.setHeader('Content-Type', 'application/json; charset=utf-8');
    res.setHeader('Transfer-Encoding', 'chunked');

    for (const book of books) {
      // Convert each book to JSON and add a delimiter
      const jsonChunk = JSON.stringify(book) + "\n---\n";
      res.write(jsonChunk);
      res.flush?.();

      // Simulate streaming effect
      await new Promise((resolve) => setTimeout(resolve, 500));
    }

    res.end();

  } catch (error) {
    console.error('Error streaming books:', error.message);
    if (!res.headersSent) {
      res.status(500).json({ message: 'Internal server error', error: error.message });
    } else {
      res.end();
    }
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

exports.getBookGroupedByCriteriaPanel = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = ["id","section_id", "level_id","title","author",
    "numberOfPages","edition","category","file_size","file_path","display_image","added_by","subject_id"];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      section_id,
      level_id,
      author,
      edition,
      category,
      added_by,
      page = 1,
      limit = 10,
      orderBy = "id",
      sort = "ASC",
      search,
    } = req.query;

    const pageNumber = parseInt(page, 10);
    let limitNumber = parseInt(limit, 10);
    const LOWER_LIMIT = 10;
    const UPPER_LIMIT = 250;
    if (isNaN(limitNumber) || limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
    if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;
    const offset = (pageNumber - 1) * limitNumber;
    const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy) ? orderBy : "id";
    const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase()) ? sort.toUpperCase() : "ASC";

    const { count, rows: books } = await book.findAndCountAll({
      where: {
        ...(section_id && {
          section_id: section_id  
        }),
        ...(level_id && {
          level_id: level_id  
        }),
        ...(author && {
          author: author  
        }),
        ...(edition && {
          edition: edition  
        }),
        ...(category && {
          category: category  
        }),
        ...(added_by && {
          added_by: added_by  
        }),

        ...(search &&{
          [Op.or]: [
            { author: { [Op.like]: `%${search}%` } },
            { title: { [Op.like]: `%${search}%` } },
          ],
        }),
      },
      include: [
        { model: subject,
          as: "subject",
          attributes:["subject_id"],
          // required: true, 
          // where: {
          //   ...(subject_id && {
          //     id: subject_id
          //   }),
          // }
        },
        { model: section,
          as: "section",
          required: true, 
          where: {
          ...(section_id && {
            id: section_id
          }),
        }
        },
        { model: level, as: "level",
          required: true, 
          where: {
          ...(level_id && {
            id: level_id
          }),
        }
        },
      ],
      distinct: true,
      limit: limitNumber,
      offset: offset,
      order: [[validOrderBy, validSort]],
    });

    if (!books.length) {
      return res.status(404).json({ message: "No books found for the specified criteria" });
    }

    res.status(200).json({
      message: "Books retrieved successfully",
      data: books,
      pagination: {
        totalBooks: count,
        totalPages: Math.ceil(count / limitNumber),
        currentPage: pageNumber,
        perPage: limitNumber,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error retrieving books", error: error.message });
  }
};