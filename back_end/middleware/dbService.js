// // dbService.js
// const db = require('../models');
// const { ValidationError, UniqueConstraintError, ForeignKeyConstraintError } = require('sequelize');

// const getUniqueFields = (Model) => {
//   return Object.entries(Model.rawAttributes)
//     .filter(([_, config]) => config.unique)
//     .map(([fieldName]) => fieldName);
// };

// const isDuplicate = async (Model, data) => {
//   const where = getUniqueFields(Model).reduce((acc, field) => {
//     if (data[field] !== undefined) acc[field] = data[field];
//     return acc;
//   }, {});

//   return Object.keys(where).length > 0 
//     ? !!(await Model.findOne({ where })) 
//     : false;
// };

// const validateForeignKeys = async (Model, data) => {
//     try {
//       const associations = Object.values(Model.associations)
//         .filter(assoc => 
//           assoc.associationType === 'BelongsTo' && // Only check belongsTo
//           data[assoc.foreignKey] !== undefined
//         );
  
//       for (const assoc of associations) {
//         const exists = await assoc.target.findByPk(data[assoc.foreignKey]);
//         if (!exists) {
//           console.warn(`Missing FK ${assoc.foreignKey}=${data[assoc.foreignKey]}`);
//           return false;
//         }
//       }
//       return true;
//     } catch (error) {
//       console.error('FK Validation Error:', error.message);
//       return false;
//     }
// };

// const insertData = async (modelName, data) => {
//   try {
//     const Model = db[modelName];
//     if (!Model) return { status: 'skipped', reason: `Model ${modelName} not found` };

//     // Check for duplicates
//     if (await isDuplicate(Model, data)) {
//       return { status: 'skipped', reason: 'Duplicate record' };
//     }

//     // Validate relationships
//     if (!(await validateForeignKeys(Model, data))) {
//       return { status: 'skipped', reason: 'Invalid foreign key' };
//     }

//     // Special handling for user password hashing
//     if (modelName === 'user') {
//       await Model.create(data, { individualHooks: true });
//     } else {
//       await Model.create(data);
//     }




//     return { status: 'inserted' };

//   } catch (error) {
//     let reason = 'Server error';
//     if (error instanceof UniqueConstraintError) {
//       reason = `Duplicate: ${error.message}`;
//     } else if (error instanceof ForeignKeyConstraintError) {
//       reason = `FK Error: ${error.message}`;
//     } else if (error instanceof ValidationError) {
//       reason = `Validation: ${error.errors.map(e => `${e.path}: ${e.message}`).join(', ')}`;
//     } else {
//       reason = error.message;
//     }
//     return { status: 'skipped', reason };
//   }
// };


// const getProcessingOrder = (models) => {
//   const sortedModels = [];
//   const visited = new Set();

//   function visit(model) {
//     if (visited.has(model)) return;
//     visited.add(model);

//     // Get dependencies (models we belong to)
//     const associations = Object.values(models[model].associations)
//       .filter(a => a.associationType === 'BelongsTo')
//       .map(a => a.target.name);

//     associations.forEach(visit);
//     sortedModels.push(model);
//   }

//   Object.keys(models).forEach(model => visit(model));
//   return sortedModels;
// };


// const exportData = async (modelName) => {
//   try {
//     const Model = db[modelName];
//     if (!Model) throw new Error(`Model ${modelName} not found`);

//     const records = await Model.findAll({ raw: true });
//     return records;
//   } catch (error) {
//     console.error('Export error:', error.message);
//     throw error;
//   }
// };

// module.exports = { insertData, getProcessingOrder, exportData };


// const db = require('../models');
// const { 
//   ValidationError, 
//   UniqueConstraintError, 
//   ForeignKeyConstraintError,
//   Op 
// } = require('sequelize');
// const { translateText } = require('./translationServices');

// // Cache for model metadata
// const modelCache = new Map();

// const getModelMetadata = (modelName) => {
//   if (modelCache.has(modelName)) {
//     return modelCache.get(modelName);
//   }

//   const Model = db[modelName];
//   if (!Model) throw new Error(`Model ${modelName} not found`);

//   const metadata = {
//     uniqueFields: Object.entries(Model.rawAttributes)
//       .filter(([_, config]) => config.unique)
//       .map(([fieldName]) => fieldName),
//     associations: Object.values(Model.associations || {})
//   };

//   modelCache.set(modelName, metadata);
//   return metadata;
// };

// const shouldTranslateValue = (value) => {
//   return typeof value === 'string' && 
//          value.trim() !== '' &&
//          !value.startsWith('{') && 
//          !value.startsWith('[');
// };

// const prepareBilingualData = async (data, sourceLanguage) => {
//   const targetLanguage = sourceLanguage === 'ar' ? 'en' : 'ar';
//   const result = {};

//   for (const [key, value] of Object.entries(data)) {
//     if (typeof value === 'object' && value !== null && !Array.isArray(value)) {
//       // Process JSON objects recursively
//       result[key] = await prepareBilingualData(value, sourceLanguage);
//     } 
//     else if (shouldTranslateValue(value)) {
//       try {
//         result[key] = {
//           [sourceLanguage]: value,
//           [targetLanguage]: await translateText(value, sourceLanguage, targetLanguage)
//         };
//       } catch (error) {
//         console.error(`Translation failed for ${key}:`, error);
//         result[key] = { [sourceLanguage]: value };
//       }
//     } else {
//       // Leave non-string and JSON values unchanged
//       result[key] = value;
//     }
//   }

//   return result;
// };

// const insertData = async (modelName, data, options = {}) => {
//   try {
//     const Model = db[modelName];
//     if (!Model) return { status: 'skipped', reason: `Model ${modelName} not found` };

//     // Process bilingual data if language is specified
//     if (options.language) {
//       data = await prepareBilingualData(data, options.language);
//     }

//     // Check for duplicates
//     const metadata = getModelMetadata(modelName);
//     const where = metadata.uniqueFields.reduce((acc, field) => {
//       if (data[field] !== undefined) acc[field] = data[field];
//       return acc;
//     }, {});

//     if (Object.keys(where).length > 0) {
//       const existing = await Model.findOne({ where, ...options });
//       if (existing) return { status: 'skipped', reason: 'Duplicate record' };
//     }

//     // Validate foreign keys
//     const invalidAssociations = await Promise.all(
//       metadata.associations
//         .filter(assoc => assoc.associationType === 'BelongsTo')
//         .map(async (assoc) => {
//           if (data[assoc.foreignKey] !== undefined) {
//             const exists = await assoc.target.findByPk(data[assoc.foreignKey], options);
//             return !exists ? assoc.foreignKey : null;
//           }
//           return null;
//         })
//     );

//     const invalidKeys = invalidAssociations.filter(Boolean);
//     if (invalidKeys.length > 0) {
//       return { status: 'skipped', reason: `Invalid foreign keys: ${invalidKeys.join(', ')}` };
//     }

//     // Create record
//     const createOptions = modelName === 'user' 
//       ? { ...options, individualHooks: true } 
//       : options;

//     await Model.create(data, createOptions);
//     return { status: 'inserted' };

//   } catch (error) {
//     let reason = 'Server error';
//     if (error instanceof UniqueConstraintError) {
//       reason = `Duplicate: ${error.message}`;
//     } else if (error instanceof ForeignKeyConstraintError) {
//       reason = `FK Error: ${error.message}`;
//     } else if (error instanceof ValidationError) {
//       reason = `Validation: ${error.errors.map(e => `${e.path}: ${e.message}`).join(', ')}`;
//     }
//     return { status: 'skipped', reason };
//   }
// };

// const extractLanguageFromNested = (obj, language) => {
//   if (Array.isArray(obj)) {
//     return obj.map(item => extractLanguageFromNested(item, language));
//   }
  
//   const result = {};
//   for (const [key, value] of Object.entries(obj)) {
//     if (value && typeof value === 'object') {
//       if ('en' in value || 'ar' in value) {
//         result[key] = value[language] || value.en || value.ar || '';
//       } else {
//         result[key] = extractLanguageFromNested(value, language);
//       }
//     } else {
//       result[key] = value;
//     }
//   }
//   return result;
// };

// const exportData = async (modelName, options = {}) => {
//   try {
//     const Model = db[modelName];
//     if (!Model) throw new Error(`Model ${modelName} not found`);

//     const language = options.language || 'en';
//     const queryOptions = {
//       raw: true,
//       attributes: options.attributes,
//       where: options.where,
//       ...options
//     };

//     // Handle include relationships if specified
//     if (options.include) {
//       queryOptions.include = parseIncludeOptions(options.include, Model);
//       queryOptions.raw = false; // Need instances for proper include handling
//     }

//     const records = await Model.findAll(queryOptions);
//     const plainRecords = queryOptions.raw ? records : records.map(r => r.get({ plain: true }));

//     // Extract requested language from bilingual fields
//     return plainRecords.map(record => 
//       extractLanguageFromNested(record, language)
//     );
//   } catch (error) {
//     console.error(`Export error for ${modelName}:`, error);
//     throw error;
//   }
// };

// const isDuplicate = async (Model, data, options = {}) => {
//   const { uniqueFields } = getModelMetadata(Model.name);
//   const where = uniqueFields.reduce((acc, field) => {
//     if (data[field] !== undefined) acc[field] = data[field];
//     return acc;
//   }, {});

//   return Object.keys(where).length > 0 
//     ? !!(await Model.findOne({ where, ...options })) 
//     : false;
// };

// const validateForeignKeys = async (Model, data, options = {}) => {
//   try {
//     const { associations } = getModelMetadata(Model.name);
//     const belongsToAssociations = associations.filter(
//       assoc => assoc.associationType === 'BelongsTo' && data[assoc.foreignKey] !== undefined
//     );

//     const results = await Promise.all(
//       belongsToAssociations.map(async (assoc) => {
//         const exists = await assoc.target.findByPk(data[assoc.foreignKey], options);
//         return { valid: !!exists, key: assoc.foreignKey, value: data[assoc.foreignKey] };
//       })
//     );

//     const invalid = results.filter(r => !r.valid);
//     if (invalid.length) {
//       console.warn('Missing foreign keys:', invalid);
//       return false;
//     }
//     return true;
//   } catch (error) {
//     console.error('FK Validation Error:', error.message);
//     return false;
//   }
// };

// const getModelRelationships = () => {
//   const sortedModels = [];
//   const visited = new Set();
//   const temp = new Set();

//   function visit(modelName) {
//     if (temp.has(modelName)) throw new Error(`Cyclic dependency detected involving ${modelName}`);
//     if (visited.has(modelName)) return;

//     temp.add(modelName);
//     const { associations } = getModelMetadata(modelName);

//     // Process dependencies first (BelongsTo associations)
//     associations
//       .filter(a => a.associationType === 'BelongsTo')
//       .forEach(a => visit(a.target.name));

//     temp.delete(modelName);
//     visited.add(modelName);
//     sortedModels.push(modelName);
//   }

//   Object.keys(db).forEach(modelName => visit(modelName));
//   return sortedModels;
// };

// const validateExportRequest = (requestedModels) => {
//   if (!requestedModels) return Object.keys(db);
  
//   const models = Array.isArray(requestedModels) 
//     ? requestedModels 
//     : requestedModels.split(',');

//   return models.filter(model => {
//     if (!db[model]) {
//       console.warn(`Skipping invalid model: ${model}`);
//       return false;
//     }
//     return true;
//   });
// };

// const parseIncludeOptions = (includeString, Model) => {
//   try {
//     return includeString.split(',').map(includeName => {
//       const association = Model.associations[includeName];
//       if (!association) {
//         throw new Error(`Invalid include: ${includeName} for model ${Model.name}`);
//       }
//       return { 
//         association: includeName,
//         attributes: association.target.primaryKeyAttributes 
//       };
//     });
//   } catch (error) {
//     console.error('Error parsing include options:', error);
//     throw new Error('Invalid include parameter format');
//   }
// };

// module.exports = { 
//   insertData,
//   exportData,
//   getModelRelationships,
//   validateExportRequest,
//   isDuplicate,
//   validateForeignKeys
// };


const db = require('../models');

const getAllModelData = async () => {
  const results = {};
  
  // Get all model names
  const modelNames = Object.keys(db).filter(key => 
    typeof db[key] === 'object' && 
    db[key].name && 
    db[key].sequelize
  );

  // Export each model's data
  for (const modelName of modelNames) {
    try {
      results[modelName] = await db[modelName].findAll({
        raw: true,
        nest: true,
        include: { all: true }
      });
    } catch (error) {
      console.error(`Error exporting ${modelName}:`, error);
      results[modelName] = [];
    }
  }

  return results;
};

module.exports = { getAllModelData };




