// controllers/bookController.js
const path = require('path');
const fs = require("fs");
const { book } = require('../models');
const { Worker } = require("worker_threads");
const { uploadFields  } = require('../utils/multerConfig');

exports.uploadFile = [
  uploadFields , 
    async (req, res) => {
        try {
            const added_by= req.user.user_id;

            const { subject_id } = req.body;

            if ( !subject_id ) {
              return res.status(400).json({ message: " subject_id is required." });
            }

            if (!req.files || !req.files['file']) {
              return res.status(400).json({ message: "No file uploaded." });
            }
    
            const file = req.files['file'][0];
            const title = file.originalname;

            console.log('\n \n File.originalname:', title); 
            const existingBook = await book.findOne({
              where: {
                title:path.parse(title).name,
                category: req.query.category,
                subject_id: req.body.subject_id,
              },
            });
            
            if (existingBook) {
              return res.status(409).json({
                message: "This file has already been uploaded.",
                book: existingBook,
              });
            }
            
            const newBook = await book.create({
                title: path.parse(title).name,
                category : req.query.category,
                subject_id,
                added_by,
                },
                {
                  individualHooks: true,
                }
            );

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
    const fileData = await book.findByPk(req.query.id);
    if (!fileData) {
      return res.status(404).json({ message: "File not found in database." });
    }
    const filePath = path.resolve(__dirname, '../storage/library', fileData.category, `${fileData.title}.pdf`);
    console.log(`\n \n fileData category ${fileData.category} --- fileData.title ${fileData.title} \n \n `);
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
