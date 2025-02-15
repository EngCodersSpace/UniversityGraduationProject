const xlsx = require("xlsx");
const fs = require("fs");
const path = require("path");
const { sequelize } = require("../models"); // Import database connection
const models = require("../models"); // Load all Sequelize models

// Get table schema (column names)
async function getTableSchema(tableName) {
    if (!models[tableName] || !models[tableName].getAttributes) {
        throw new Error(`Table '${tableName}' does not exist in the database.`);
    }
    return Object.keys(models[tableName].getAttributes());
}

exports.uploadExcel = async (req, res) => {
    try {
        const { tableName } = req.body; // Get table name from request

        if (!tableName) {
            return res.status(400).json({ message: "Table name is required." });
        }

        if (!req.file) {
            return res.status(400).json({ message: "No file uploaded." });
        }

        // Read and parse Excel file
        const filePath = path.join(__dirname, "../uploads", req.file.filename);
        const workbook = xlsx.readFile(filePath);
        const sheetName = workbook.SheetNames[0];
        const data = xlsx.utils.sheet_to_json(workbook.Sheets[sheetName]);

        // Get the table schema
        const tableColumns = await getTableSchema(tableName);

        // Transform data to match the table schema
        const transformedData = data.map(row => {
            let newRow = {};
            tableColumns.forEach(field => {
                if (row[field] !== undefined) {
                    newRow[field] = row[field];
                }
            });
            return newRow;
        });

        if (transformedData.length === 0) {
            return res.status(400).json({ message: "No matching data found for the selected table." });
        }

        // Insert data into the selected table
        await models[tableName].bulkCreate(transformedData, { ignoreDuplicates: true });

        // Delete the file after processing
        fs.unlinkSync(filePath);

        res.json({ message: `Data successfully uploaded to table '${tableName}'!` });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error processing file", error });
    }
};