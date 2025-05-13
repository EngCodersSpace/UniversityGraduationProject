// utils/relationHelper.js

/**
 * Dynamically fetches Sequelize associations for a given model
 * @param {string} tableName - The base model name (e.g., 'users')
 * @param {object} db - The Sequelize models object
 * @returns {Array} - Array of include definitions for Sequelize
 */
function getTableRelations(tableName, db, depth = 1) {
  const model = db[tableName];
  if (!model || !model.associations || depth <= 0) {
    return [];
  }

  const includes = [];

  for (const assocName in model.associations) {
    const association = model.associations[assocName];
    const targetModel = association.target;

    // Check if the association is of type HasMany (which supports separate)
    const associationInclude = {
      model: targetModel,
      as: association.as,
      required: false,  // Include even if there's no related data
    };

    // Apply separate only for HasMany associations
    if (association.associationType === 'HasMany') {
      associationInclude.separate = true;
    }

    // Recursively handle nested relations with reduced depth
    const nestedIncludes = getTableRelations(targetModel.name, db, depth - 1);
    if (nestedIncludes.length > 0) {
      associationInclude.include = nestedIncludes;
    }

    includes.push(associationInclude);
  }

  return includes;
}


module.exports = {
getTableRelations,
};
  