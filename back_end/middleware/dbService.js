const db = require('../models');
const { ValidationError, UniqueConstraintError, ForeignKeyConstraintError } = require('sequelize');

const getUniqueFields = (Model) => {
  return Object.entries(Model.rawAttributes)
    .filter(([_, config]) => config.unique)
    .map(([fieldName]) => fieldName);
};

const isDuplicate = async (Model, data) => {
  const where = getUniqueFields(Model).reduce((acc, field) => {
    if (data[field] !== undefined) acc[field] = data[field];
    return acc;
  }, {});

  return Object.keys(where).length > 0 
    ? !!(await Model.findOne({ where })) 
    : false;
};

const validateForeignKeys = async (Model, data) => {
    try {
      const associations = Object.values(Model.associations)
        .filter(assoc => 
          assoc.associationType === 'BelongsTo' && // Only check belongsTo
          data[assoc.foreignKey] !== undefined
        );
  
      for (const assoc of associations) {
        const exists = await assoc.target.findByPk(data[assoc.foreignKey]);
        if (!exists) {
          console.warn(`Missing FK ${assoc.foreignKey}=${data[assoc.foreignKey]}`);
          return false;
        }
      }
      return true;
    } catch (error) {
      console.error('FK Validation Error:', error.message);
      return false;
    }
};

const insertData = async (modelName, data) => {
  try {
    const Model = db[modelName];
    if (!Model) return { status: 'skipped', reason: `Model ${modelName} not found` };

    // Check for duplicates
    if (await isDuplicate(Model, data)) {
      return { status: 'skipped', reason: 'Duplicate record' };
    }

    // Validate relationships
    if (!(await validateForeignKeys(Model, data))) {
      return { status: 'skipped', reason: 'Invalid foreign key' };
    }

    // Special handling for user password hashing
    if (modelName === 'user') {
      await Model.create(data, { individualHooks: true });
    } else {
      await Model.create(data);
    }

    return { status: 'inserted' };

  } catch (error) {
    let reason = 'Server error';
    if (error instanceof UniqueConstraintError) {
      reason = `Duplicate: ${error.message}`;
    } else if (error instanceof ForeignKeyConstraintError) {
      reason = `FK Error: ${error.message}`;
    } else if (error instanceof ValidationError) {
      reason = `Validation: ${error.errors.map(e => `${e.path}: ${e.message}`).join(', ')}`;
    } else {
      reason = error.message;
    }
    return { status: 'skipped', reason };
  }
};


module.exports = { insertData };