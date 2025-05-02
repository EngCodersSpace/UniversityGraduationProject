// controllers/bookController.js
const path = require('path');
const fs = require("fs");
const { book,section,level} = require('../models');
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

// not needed this 
exports.uploadFile1 = async (req, res) => {
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
          subject_id: req.body.subject_id || null ,
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

exports.uploadFile = async (req, res) => {
  try {
    if (!req.query.category) {
      return res.status(400).json({ message: 'Category is required' });
    }

    // Parse section and level IDs from query
    const sectionIds = req.query.section_ids ? [...new Set(req.query.section_ids.split(','))] : [];
    const levelIds = req.query.level_ids ? [...new Set(req.query.level_ids.split(','))] : [];

    // Determine if book is shared (multiple sections/levels) or specific
    const isSharedBook = sectionIds.length > 1 || levelIds.length > 1;

    // Get all sections and levels data
    const [sections, levels] = await Promise.all([
      sectionIds.length ? section.findAll({ where: { id: sectionIds } }) : Promise.resolve([]),
      levelIds.length ? level.findAll({ where: { id: levelIds } }) : Promise.resolve([])
    ]);

    // Validate all sections/levels exist if IDs were provided
    if ((sectionIds.length && sections.length !== sectionIds.length) || 
        (levelIds.length && levels.length !== levelIds.length)) {
      return res.status(404).json({ message: 'One or more sections/levels not found' });
    }

    // Determine upload folder path
    let uploadPath;
    let displayImageBasePath;
    
    if (isSharedBook) {
      uploadPath = `library/${req.query.category}/shared/books`;
      displayImageBasePath = `library/${req.query.category}/shared/photos`;
    } else {
      const sectionName = sections[0] ? JSON.parse(sections[0].section_name).en : 'common';
      const levelName = levels[0] ? levels[0].level_name : 'common';
      uploadPath = `library/${req.query.category}/${sectionName}/${levelName}/books`;
      displayImageBasePath = `library/${req.query.category}/${sectionName}/${levelName}/photos`;
    }

    // Process file upload
    uploadFields(uploadPath, '').single('file')(req, res, async (err) => {
      if (err) return res.status(400).json({ message: 'Upload failed', error: err.message });
      if (!req.file) return res.status(400).json({ message: 'No file provided' });

      try {
        const filepath = path.join('storage', req.file.path);
        const bookDetails = await extractBookDetails(filepath);

        // Create display image only once
        const displayImagePath = path.join('storage', displayImageBasePath, `${req.file.hash}.png`);
        await mkdirAsync(path.dirname(displayImagePath), { recursive: true });
        
        // Only extract image if it doesn't exist yet
        try {
          await fs.promises.access(displayImagePath);
          console.log('Display image already exists, skipping extraction');
        } catch {
          await extractDisplayImage(filepath, displayImagePath);
        }

        // Create book records for all section-level combinations
        const sectionLevelCombinations = [];
        
        if (sectionIds.length === 0 && levelIds.length === 0) {
          sectionLevelCombinations.push({ sectionId: null, levelId: null });
        } else {
          const effectiveSections = sections.length ? sections : [{ id: null }];
          const effectiveLevels = levels.length ? levels : [{ id: null }];
          
          for (const section of effectiveSections) {
            for (const level of effectiveLevels) {
              sectionLevelCombinations.push({
                sectionId: section.id,
                levelId: level.id
              });
            }
          }
        }

        const createdBooks = [];
        for (const { sectionId, levelId } of sectionLevelCombinations) {
          try {
            const newBook = await book.create({
              title: bookDetails.title || req.file.originalname,
              category: req.query.category,
              subject_id: req.body.subject_id || null,
              added_by: req.user.user_id,
              section_id: sectionId,
              level_id: levelId,
              original_name: req.file.originalname,
              file_path: filepath,
              author: bookDetails.author,
              edition: bookDetails.edition,
              numberOfPages: bookDetails.totalPages,
              file_size: bookDetails.file_size,
              display_image: displayImagePath,
              is_shared: isSharedBook
            });
            createdBooks.push(newBook);
          } catch (error) {
            console.error(`Failed to create book record for section ${sectionId}, level ${levelId}:`, error);
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
          storage_type: isSharedBook ? 'shared' : 'specific',
          file_info: {
            path: filepath,
            size: req.file.size,
            hash: req.file.hash
          },
          books: createdBooks.map(b => ({
            id: b.id,
            title: b.title,
            section_id: b.section_id,
            level_id: b.level_id,
            is_shared: b.is_shared
          }))
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

    const filePath = path.resolve(__dirname, '..', `${fileData.file_path}`);
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
      return res.status(404).json({ message: 'No books found for the specified criteria.' });
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
