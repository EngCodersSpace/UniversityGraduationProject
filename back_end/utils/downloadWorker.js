const fs = require("fs").promises; // Use promises for non-blocking I/O
const path = require("path");
const { workerData, parentPort } = require("worker_threads");
const { filePath, range } = workerData;

// Configurable download path
const downloadPath = process.env.DOWNLOAD_PATH || path.join(__dirname, "../downloads");

async function downloadFileInBackground() {
  try {
    // Validate file path
    if (!filePath || typeof filePath !== "string") {
      throw new Error("Invalid file path provided.");
    }

    // Check if source file exists
    try {
      await fs.access(filePath, fs.constants.R_OK);
    } catch {
      throw new Error("Source file does not exist or is not accessible.");
    }

    // Ensure download directory exists
    await fs.mkdir(downloadPath, { recursive: true });

    const fileName = path.basename(filePath);
    const downloadFilePath = path.join(downloadPath, fileName);

    // Get file stats
    const stat = await fs.stat(filePath);
    const fileSize = stat.size;

    // Handle range requests
    let startPos = 0;
    let endPos = fileSize - 1;

    if (range) {
      const [start, end] = range.replace(/bytes=/, "").split("-");
      startPos = parseInt(start, 10);
      endPos = end ? parseInt(end, 10) : fileSize - 1;

      if (startPos >= fileSize || endPos >= fileSize) {
        throw new Error("Invalid range specified.");
      }
    }

    console.log(`Downloading range: ${startPos}-${endPos}`);

    const readStream = fs.createReadStream(filePath, { start: startPos, end: endPos });
    const writeStream = fs.createWriteStream(downloadFilePath);

    let downloadedBytes = 0;
    const totalBytes = endPos - startPos + 1;

    // Send progress updates
    readStream.on("data", (chunk) => {
      downloadedBytes += chunk.length;
      const percentage = ((downloadedBytes / totalBytes) * 100).toFixed(2);
      parentPort.postMessage({ status: "progress", percentage });
    });

    // Handle completion
    writeStream.on("finish", () => {
      console.log("Download completed successfully:", downloadFilePath);
      parentPort.postMessage({ status: "success", filePath: downloadFilePath });
    });

    // Handle errors
    writeStream.on("error", (err) => {
      console.error("Error writing file:", err);
      parentPort.postMessage({ status: "error", error: err.message });
    });

    readStream.on("error", (err) => {
      console.error("Error reading file:", err);
      parentPort.postMessage({ status: "error", error: err.message });
    });

    // Pipe data from read stream to write stream
    readStream.pipe(writeStream);

  } catch (error) {
    console.error("Error during download process:", error);
    parentPort.postMessage({ status: "error", error: error.message });
  }
}

// Start the download process
downloadFileInBackground();