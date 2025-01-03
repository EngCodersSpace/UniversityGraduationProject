const fs = require("fs");
const path = require("path");
const { workerData, parentPort } = require("worker_threads");

const { filePath, id } = workerData;
const downloadPath = path.join(__dirname, "../storage", "downloads");

// Ensure the download folder exists
if (!fs.existsSync(downloadPath)) {
  fs.mkdirSync(downloadPath, { recursive: true });
}

const fileName = path.basename(filePath);
const downloadFilePath = path.join(downloadPath, fileName);

// Function to simulate download
function downloadFileInBackground() {
  try {
    const stat = fs.statSync(filePath);
    const fileSize = stat.size;

    const range = workerData.range; // You could pass range information to the worker if needed
    if (range) {
      // Handle partial content here
      const [start, end] = range.replace(/bytes=/, "").split("-");
      const startPos = parseInt(start, 10);
      const endPos = end ? parseInt(end, 10) : fileSize - 1;
      const chunkSize = endPos - startPos + 1;

      const readStream = fs.createReadStream(filePath, { start: startPos, end: endPos });
      const writeStream = fs.createWriteStream(downloadFilePath);

      readStream.pipe(writeStream);

      writeStream.on("finish", () => {
        parentPort.postMessage({ status: "success", filePath: downloadFilePath });
      });

      readStream.on("error", (err) => {
        parentPort.postMessage({ status: "error", error: err.message });
      });
    } else {
      // Handle full file download
      fs.copyFile(filePath, downloadFilePath, (err) => {
        if (err) {
          console.error("Download failed:", err);
          parentPort.postMessage({ status: "error", error: err.message });
        } else {
          parentPort.postMessage({ status: "success", filePath: downloadFilePath });
        }
      });
    }
  } catch (error) {
    parentPort.postMessage({ status: "error", error: error.message });
  }
}

// Start the background download process
downloadFileInBackground();
