const crypto = require('crypto');
const path = require('path');
const fs = require('fs');

function calculateFileHash(filePath) {
    return new Promise((resolve, reject) => {
        const hash = crypto.createHash('SHA256'); 
        const stream = fs.createReadStream(filePath);

        stream.on('data', (chunk) => hash.update(chunk));
        stream.on('end', () => resolve(hash.digest('hex')));
        stream.on('error', (err) => reject(err));
    });
}

async function isDuplicateFile(hash, category) {
    const categoryFolder = path.resolve(__dirname, '../storage/library', category, 'books');
    const files = await fs.promises.readdir(categoryFolder);

    return files.some(file => file.includes(hash));
}
module.exports={calculateFileHash,isDuplicateFile}