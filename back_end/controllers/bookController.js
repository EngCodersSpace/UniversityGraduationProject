
// const BASE_URL = process.env.BASE_URL;
// const UPLOAD_DIR = process.env.UPLOAD_DIR;
// const uniqueName = `${Date.now()}_${file.originalname}`;
// const fileUrl = `${BASE_URL}/${category}/${uniqueName}`;
// npm install pdf2pic sharp



// const fs = require('fs-extra');
// const getStoragePaths = require('../utils/filePaths'); 
// const extractDisplayImage=require('../utils/imageExtractor');

// controllers/bookController.js

const path = require('path');
const fs = require("fs");
const { book } = require('../models');
const { Worker } = require("worker_threads");

// const  upload = require('../utils/multerConfig');

const { uploadFields  } = require('../utils/multerConfig');

exports.uploadFile = [
  uploadFields , 
    async (req, res) => {
        try {
            const {  title, subject_id, added_by } = req.body;

            if (!title || !subject_id || !added_by) {
                return res.status(400).json({ message: " title, subject_id, and added_by are required." });
            }

            const { file } = req;
            if (!file) {
                return res.status(400).json({ message: "No file uploaded." });
            }
            console.log ('\n  file   \n ' );

            if (!file.mimetype.includes('pdf')) {
                return res.status(400).json({ message: "Only PDF files are allowed." });
            }

            const newBook = await book.create({
                title,
                category,
                subject_id,
                added_by,
            });

            res.status(200).json({
                message: "File uploaded successfully.",
                book: newBook,
            });
        } catch (error) {
            console.error("Error during file upload:", error);
            res.status(500).json({ message: "An error occurred while uploading the file.", error: error.message });
        }
    },
];



exports.downloadFile = async (req, res) => {
  try {
    const { id } = req.params;
    const fileData = await book.findByPk(id);
    if (!fileData) {
      return res.status(404).json({ message: "File not found in database." });
    }
    const filePath = path.join(__dirname, `../${fileData.file_path}`);
    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ message: "File not found on server." });
    }

    // start download using worker_threads 
    const worker = new Worker("./utils/downloadWorker.js", {
      workerData: { filePath }
    });
    worker.on("message", (message) => {
      if (message.status === "success") {
        res.status(200).json({ message: "Download started in the background.", path: message.filePath });
      }
    });
    worker.on("error", (err) => {
      res.status(500).json({ message: "Error occurred during the download process.", error: err.message });
    });
    
    res.status(200).json({ message: "Download started in the background." });
  } catch (error) {
    console.error("Error during download:", error);
    res.status(500).json({ message: "Failed to start download.", error: error.message });
  }
};






// axios({
// method: 'get',
// url: url,
// responseType: 'stream',
// }).then((response) => {
// const writer = fs.createWriteStream(filePath);
// response.data.pipe(writer);

// writer.on('finish', () => {
//     console.log('Download completed!');
// });

// writer.on('error', (err) => {
//     console.error('Download failed:', err);
// });
// });

// router.get('/books', async (req, res) => {
//     const { levelId, sectionId, category, page = 1, size = 10 } = req.query;
//     const limit = parseInt(size);
//     const offset = (parseInt(page) - 1) * limit;
  
//     const where = {};
//     if (category) where.category = category; // فلترة حسب الفئة (Lecture, Reference, etc.)
  
//     try {
//       const { count, rows } = await Book.findAndCountAll({
//         where,
//         include: [
//           {
//             model: Level,
//             through: { attributes: [] }, // منع عرض جدول الوسيط
//             where: levelId ? { id: levelId } : undefined, // فلترة حسب المستوى
//           },
//           {
//             model: Section,
//             through: { attributes: [] }, // منع عرض جدول الوسيط
//             where: sectionId ? { id: sectionId } : undefined, // فلترة حسب القسم
//           },
//         ],
//         limit,
//         offset,
//         order: [['title', 'ASC']], // ترتيب حسب العنوان
//       });
  
//       res.json({
//         totalItems: count,
//         totalPages: Math.ceil(count / limit),
//         currentPage: parseInt(page),
//         books: rows,
//       });
//     } catch (error) {
//       res.status(500).json({ message: 'حدث خطأ أثناء البحث', error });
//     }
// });
  
// const sharp = require('sharp');
// router.post('/upload', upload.single('bookFile'), async (req, res) => {
//   const { title, author, subject_id, category } = req.body;

//   try {
//     const thumbnailPath = `uploads/thumbnails/${Date.now()}-thumbnail.jpg`;

//     // Generate thumbnail
//     await sharp(req.file.path)
//       .resize(200, 300) // Width: 200px, Height: 300px
//       .toFile(thumbnailPath);

//     const newBook = await Book.create({
//       title,
//       author,
//       subject_id,
//       category,
//       file_path: req.file.path,
//       display_image: thumbnailPath,
//       file_size: req.file.size / (1024 * 1024), // Convert bytes to MB
//     });

//     res.status(201).json({ message: 'Book uploaded successfully!', book: newBook });
//   } catch (error) {
//     res.status(500).json({ message: 'Error uploading book', error });
//   }
// });

// router.get('/books', async (req, res) => {
//   const { page = 1, size = 10 } = req.query; // Default: page 1, 10 items per page
//   const limit = parseInt(size);
//   const offset = (parseInt(page) - 1) * limit;

//   try {
//     const { count, rows } = await Book.findAndCountAll({
//       limit,
//       offset,
//       order: [['title', 'ASC']], // Sort by title
//     });

//     res.json({
//       totalItems: count,
//       totalPages: Math.ceil(count / limit),
//       currentPage: parseInt(page),
//       books: rows,
//     });
//   } catch (error) {
//     res.status(500).json({ message: 'Error fetching books', error });
//   }
// });

// const sharp = require('sharp');
// sharp('output.jpg')
//     .resize({ width: 300 }) // Resize to thumbnail size
//     .toFile('optimized_thumbnail.jpg', (err, info) => {
//         if (err) throw err;
//         console.log('Thumbnail created:', info);
// });

// async function getBooksByCategory(req, res) {
//     try {
//         const { category } = req.params;
//         const books = await Book.findAll({
//             where: { category },
//             attributes: ["id", "title", "author", "thumbnailPath"],
//         });
//         res.status(200).json(books);
//     } catch (err) {
//         console.error("Error fetching books:", err);
//         res.status(500).json({ error: "Failed to fetch books" });
//     }
// }


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
