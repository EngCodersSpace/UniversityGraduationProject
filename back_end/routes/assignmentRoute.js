const express = require('express');
const router = express.Router();
const CRUD = require('../controllers/assignmentController');
const { verifyToken } = require('../middleware/authMiddleware');

router.use(verifyToken);

router.post('/upload-assignment-doctor', CRUD.createAssignment);
router.post('/check-files', CRUD.getFileDetails);
router.post('/upload-files-assignment-doctor',CRUD.uploadFileForAssignment);
router.post('/upload-files-assignment-student', CRUD.uploadFilesAttachment);

router.get('/get-assignments-subject',CRUD.getAssignmentsOfSubject);
router.get('/get-all-students-assignment', CRUD.getStudentsAndFilesByAssignment);
router.get('/download-assignment-files', CRUD.downloadFile);
router.get('/download-files', CRUD.doctorDownloadFile);

router.put('/update-assignment', CRUD.updateAssigment);
router.put('/update-student-assignment-status', CRUD.updateAssignmentStatus);
router.put('/update-student-assignment-complete', CRUD.updateStudentComplete);

router.delete('/delete-assignment', CRUD.deleteAssignment);
router.delete('/delete-assignment-files', CRUD.deleteAssigmentFiles);
router.delete('/delete-attachment-files', CRUD.deleteAttachmentFiles);

module.exports = router;