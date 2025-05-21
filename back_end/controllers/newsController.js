// controllers/newsController.js
const {news, user} = require('../models');
const { uploadPhoto } = require("../utils/multerConfig");
const path = require('path');
const fs = require('fs');
const dayjs = require('dayjs');

const customParseFormat = require('dayjs/plugin/customParseFormat');
dayjs.extend(customParseFormat);


// create with upload photo
exports.createNewsWithPhoto =async (req, res) => {

  uploadPhoto("News", "user").single("file")(req, res, async (err) => {
    if (err) {
      return res.status(400).json({
        message: "Error during photo upload.",
        error: err.message,
      });
    }

    try {
      const { title, content } = req.body;
      const publisher_id = req.user.user_id;

      if (!title || !content || !publisher_id) {
        return res.status(400).json({ message: "Missing required fields." });
      }

      const createdNews = await news.create({
        title,
        content,
        publisher_id,
        time:dayjs().format('YYYY-MM-DD, hh:mm A') ,
        image: null, 
        include:[
          {
            model:user ,as:'user',
            attributes:['user_id','user_name']
          }
        ]
      });

      if (req.file) {
        const oldFilePath = req.file.path;
        const fileExtension = path.extname(req.file.originalname);
        const newFileName = `news_${createdNews.id}${fileExtension}`;
        const newFilePath = path.join(path.dirname(oldFilePath), newFileName);

        fs.renameSync(oldFilePath, newFilePath);

        createdNews.image = `News/user/${newFileName}`;
        await createdNews.save();
      }

      res.status(201).json({
        message: "News created successfully.",
        data: createdNews,
      });

    } catch (error) {
      console.error("Error creating news:", error.message);
      res.status(500).json({
        message: "Internal server error.",
        error: error.message,
      });
    }
  });

};

// create new without photo
exports.createNews = async (req, res) => {
  try {
    const newsItem = await news.create(req.body);
    res.status(201).json({message:"create New Successfully",data:newsItem});
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
// only upload photo for specific new
exports.uploadPhotoForNews = async (req, res) => {
  try {
    const {id } = req.params;

    const existingNews = await news.findByPk(id);

    if (!existingNews) {
      return res.status(404).json({ message: "News item not found." });
    }

    uploadPhoto("News", "user").single("file")(req, res, async (err) => {
      if (err) {
        return res.status(400).json({
          message: "Error during photo upload.",
          error: err.message,
        });
      }

      if (!req.file) {
        return res.status(400).json({ message: "No photo provided." });
      }

      try {
        const oldFilePath = req.file.path;
        const fileExtension = path.extname(req.file.originalname);
        const newFileName = `news_${id}_${Date.now()}${fileExtension}`;
        const newFilePath = path.join(path.dirname(oldFilePath), newFileName);

        fs.renameSync(oldFilePath, newFilePath);

        existingNews.image = `News/user/${newFileName}`;
        await existingNews.save();

        res.status(201).json({
          message: "Photo uploaded successfully.",
          filePath: existingNews.image,
        });
      } catch (error) {
        console.error("File processing error:", error.message);
        res.status(500).json({
          message: "Internal server error during file rename/save.",
          error: error.message,
        });
      }
    });
  } catch (error) {
    console.error("Server error:", error.message);
    res.status(500).json({
      message: "Internal server error.",
      error: error.message,
    });
  }
};


exports.getAllNews = async (req, res) => {
  try {
    const newsList = await news.findAll();
    res.status(200).json({message:"Get All News Successfully",data:newsList});
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getAllNewsWithLimit = async (req, res) => {
  try {
    const { limit } = req.query;

    const newsList = await news.findAll({
      order: [['time', 'DESC']],
      ...(limit && { limit: parseInt(limit) }) 
    });

    res.status(200).json({ message: "Get News Successfully", data: newsList });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};



//  get image from path by id (req.query.id)
exports.getImageOfNews1 = async (req, res) => {
  try {

      if (!req.query.id) {
          return res.status(400).json({message: "News id  is required" });
      }

      const ImageOfNews = await news.findOne({
          where: { id: req.query.id },
      });

      if (ImageOfNews.length === 0) {
        return res.status(204).json();
      }

      if (!ImageOfNews) {
          return res.status(404).json({ success: false, message: "No image found for the specified News" });
      }
      const imagePath = path.join(__dirname  , '..',"storage" ,ImageOfNews.image);
      console.log('\n \n path of image:',imagePath)
      res.sendFile(imagePath);
  } catch (error) {
      console.error("Error fetching new's image:", error);
      res.status(500).json({message: "An error occurred while fetching new's image", error: error.message });
  }
};

// get image as stream
exports.getImageOfNews = async (req, res) => {
  try {
    const newsId = req.query.id;

    if (!newsId) {
      return res.status(400).json({ message: "News id is required" });
    }

    const ImageOfNews = await news.findOne({
      where: { id: newsId },
    });

    if (!ImageOfNews || !ImageOfNews.image) {
      return res.status(404).json({ message: "No image found for the specified News" });
    }

    const imagePath = path.join(__dirname, '..', 'storage', ImageOfNews.image);

    if (!fs.existsSync(imagePath)) {
      return res.status(404).json({ message: "Image file not found on server" });
    }

    const ext = path.extname(imagePath).toLowerCase();
    const mimeType = {
      '.jpg': 'image/jpeg',
      '.jpeg': 'image/jpeg',
      '.png': 'image/png',
      '.gif': 'image/gif',
    }[ext] || 'application/octet-stream';

    res.setHeader('Content-Type', mimeType);

    const readStream = fs.createReadStream(imagePath);
    readStream.pipe(res);

    readStream.on('error', (err) => {
      console.error("Stream error:", err.message);
      res.status(500).end("Error reading image file");
    });

  } catch (error) {
    console.error("Error fetching News image:", error.message);
    res.status(500).json({ message: "Internal server error", error: error.message });
  }
};




exports.getNewsById = async (req, res) => {
  try {
    const newsItem = await news.findByPk(req.params.id);
    if (!newsItem) {
      return res.status(404).json({ error: 'News not found' });
    }
    res.status(200).json({message:"Get New Successfully",data:newsItem});
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};


exports.updateNewsWithPhoto = async (req, res) => {
  uploadPhoto("News", "user").single("file")(req, res, async (err) => {
    if (err) {
      return res.status(400).json({
        message: "Error during photo upload.",
        error: err.message,
      });
    }

    try {
      const newsId = req.params.id;
      const { title, content } = req.body;
      const publisher_id = req.user.user_id;

      const existingNews = await news.findByPk(newsId);
      if (!existingNews) {
        return res.status(404).json({ message: "News not found." });
      }

      if (title) existingNews.title = title;
      if (content) existingNews.content = content;
      existingNews.publisher_id = publisher_id; 
      existingNews.time = dayjs().format('YYYY-MM-DD, hh:mm A'); 

      if (req.file) {
        const oldFilePath = req.file.path;
        const fileExtension = path.extname(req.file.originalname);
        const newFileName = `news_${existingNews.id}${fileExtension}`;
        const newFilePath = path.join(path.dirname(oldFilePath), newFileName);

        fs.renameSync(oldFilePath, newFilePath);
        existingNews.image = `News/user/${newFileName}`;
      }

      await existingNews.save();

      res.status(200).json({
        message: "News updated successfully.",
        data: existingNews,
      });

    } catch (error) {
      console.error("Error updating news:", error.message);
      res.status(500).json({
        message: "Internal server error.",
        error: error.message,
      });
    }
  });
};



exports.deleteNews = async (req, res) => {
  try {
    const deleted = await news.findByPk(req.params.id);
    if (!deleted) {
      return res.status(404).json({ error: 'News not found' });
    }
    const imagePath = path.resolve('storage',deleted.image);
    console.log("\n \n image path:",imagePath,"\n \n ");
    if (fs.existsSync(imagePath)) {
      await fs.promises.unlink(imagePath);
      console.log(`Deleted file: ${imagePath}`);
    } else {
      console.warn(`File not found: ${imagePath}`);
    }
    
    if (!deleted) {
      return res.status(404).json({ error: 'News not found' });
    }
    await deleted.destroy();
    res.status(200).json({ message: 'News deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};