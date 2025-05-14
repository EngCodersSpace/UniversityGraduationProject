// controllers/newsController.js
const {news, user} = require('../models');
const { uploadPhoto } = require("../utils/multerConfig");
const path = require('path');
const fs = require('fs');

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
        image: null, // will update below if file is present
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

// no update  delete and create new
exports.updateNews = async (req, res) => {
  try {
    const updated = await news.update(req.body, {
      where: { id: req.params.id }
    });
    if (!updated[0]) {
      return res.status(404).json({ error: 'News not found or nothing to update' });
    }
    res.status(200).json({ message: 'News updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
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