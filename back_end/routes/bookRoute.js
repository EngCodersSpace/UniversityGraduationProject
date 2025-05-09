//  routes/bookRoute.js
const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/bookController');
const {checkPermission} = require('../middleware/roleMiddleware');
const { verifyToken } = require('../middleware/authMiddleware');
router.use(verifyToken);

router.post('/checkFileDuplicate',  CRUD.checkFileDuplicate);
router.post('/upload',checkPermission('books', 'write'),  CRUD.uploadFile);
router.get('/download', CRUD.downloadFile);
router.get('/get-all-books-stream', CRUD.streamBooks);
router.get('/get-imageOfbook', CRUD.getImageOfBook);
router.get('/get-bookPanel', CRUD.getBookGroupedByCriteriaPanel);
router.delete('/delete',checkPermission('books', 'write'), CRUD.deleteBook);

module.exports = router;