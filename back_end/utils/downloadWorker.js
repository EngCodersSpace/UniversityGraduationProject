// utils/downloadWorker.js
const fs = require("fs");
const path = require("path");
const { workerData, parentPort } = require("worker_threads");
const { filePath, range } = workerData;
// const downloadPath = path.join(__dirname, "../storage", "downloads"); // for download inside storage
const downloadPath = process.env.DOWNLOAD_PATH || path.join(__dirname, "../downloads"); // for download out storage
 

if (!filePath || typeof filePath !== "string") {
  parentPort.postMessage({ status: "error", error: "Invalid file path provided." });
  return;
}
if (!fs.existsSync(filePath)) {
  parentPort.postMessage({ status: "error", error: "Source file does not exist." });
  return;
}
if (!fs.existsSync(downloadPath)) {
  fs.mkdirSync(downloadPath, { recursive: true });
}
const fileName = path.basename(filePath);
const downloadFilePath = path.join(downloadPath, fileName);

function downloadFileInBackground() {
  try {
    const stat = fs.statSync(filePath);
    const fileSize = stat.size;

    if (range) {
      const [start, end] = range.replace(/bytes=/, "").split("-");
      const startPos = parseInt(start, 10);
      const endPos = end ? parseInt(end, 10) : fileSize - 1;

      console.log(`Downloading range: ${startPos}-${endPos}`);

      const readStream = fs.createReadStream(filePath, { start: startPos, end: endPos });
      const writeStream = fs.createWriteStream(downloadFilePath);

      readStream.pipe(writeStream);

      writeStream.on("finish", () => {
        console.log("Download completed successfully:", downloadFilePath);
        parentPort.postMessage({ status: "success", filePath: downloadFilePath });
      });

      writeStream.on("error", (err) => {
        console.error("Error writing file:", err);
        parentPort.postMessage({ status: "error", error: err.message });
      });

      readStream.on("error", (err) => {
        console.error("Error reading file:", err);
        parentPort.postMessage({ status: "error", error: err.message });
      });
    } else {
      console.log("Downloading entire file:", filePath);
      const readStream = fs.createReadStream(filePath);
      const writeStream = fs.createWriteStream(downloadFilePath);

      readStream.pipe(writeStream);

      writeStream.on("finish", () => {
        console.log("Download completed successfully:", downloadFilePath);
        parentPort.postMessage({ status: "success", filePath: downloadFilePath });
      });

      writeStream.on("error", (err) => {
        console.error("Error writing file:", err);
        parentPort.postMessage({ status: "error", error: err.message });
      });

      readStream.on("error", (err) => {
        console.error("Error reading file:", err);
        parentPort.postMessage({ status: "error", error: err.message });
      });
    }
  } catch (error) {
    console.error("Error during download process:", error);
    parentPort.postMessage({ status: "error", error: error.message });
  }
}

downloadFileInBackground();