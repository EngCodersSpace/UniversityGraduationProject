// utils/uploadWorker.js
const fs = require("fs");
const path = require("path");
const { workerData, parentPort } = require("worker_threads");

const { fileData, uploadPath } = workerData;

if (!fileData || !uploadPath) {
  parentPort.postMessage({ status: "error", error: "Invalid input data provided." });
  return;
}

if (!fs.existsSync(uploadPath)) {
  fs.mkdirSync(uploadPath, { recursive: true });
}

const fileName = fileData.fileName || "uploaded_file";
const fileBuffer = Buffer.from(fileData.content, "base64"); // Assuming file content is sent as Base64
const targetFilePath = path.join(uploadPath, fileName);

function uploadFileInBackground() {
  try {
    console.log(`Uploading file: ${fileName}`);

    fs.writeFile(targetFilePath, fileBuffer, (err) => {
      if (err) {
        console.error("Error during file upload:", err);
        parentPort.postMessage({ status: "error", error: err.message });
        return;
      }
      console.log("Upload completed successfully:", targetFilePath);
      parentPort.postMessage({ status: "success", filePath: targetFilePath });
    });
  } catch (error) {
    console.error("Error during upload process:", error);
    parentPort.postMessage({ status: "error", error: error.message });
  }
}

uploadFileInBackground();
