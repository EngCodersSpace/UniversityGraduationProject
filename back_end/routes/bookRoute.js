//  routes/bookRoute.js

const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/bookController');
const { verifyToken } = require('../middleware/authMiddleware');

router.use(verifyToken);

router.post('/upload',verifyToken,  CRUD.uploadFile);
router.get('/download', CRUD.downloadFile);
router.get('/get-all-books', CRUD.getBooksByCategory);
router.delete('/delete', CRUD.deleteBook);


module.exports = router;