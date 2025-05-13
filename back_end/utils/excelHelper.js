// utils/excelHelper.js

/**
 * Flattens multilingual JSON fields in a Sequelize result object.
 * E.g., { name: { en: "Hello", ar: "مرحبا" } } becomes:
 *       { name_en: "Hello", name_ar: "مرحبا" }
 *
 * @param {Object} record - A single record from Sequelize .toJSON()
 * @returns {Object} - Flattened object ready for Excel
*/
function flattenMultilingualFields(obj, lang = 'en') {
  // console.log('Original:', obj); 

  const flattened = {};

  for (const key in obj) {
    let value = obj[key];

    // Try to parse stringified JSON
    if (typeof value === 'string') {
      try {
        const parsed = JSON.parse(value);
        value = parsed;
      } catch (e) {
        // Not a JSON string, keep as-is
      }
    }

    // Check if it's a multilingual object
    if (
      typeof value === 'object' &&
      value !== null &&
      !Array.isArray(value) &&
      'en' in value &&
      'ar' in value
    ) {
      flattened[key] = value[lang];
    } else if (typeof value === 'object' && value !== null) {
      // Convert other nested objects to string
      flattened[key] = JSON.stringify(value);
    } else {
      flattened[key] = value;
    }
  }

  // console.log('Flattened:', flattened); 
  return flattened;
}
  
// for import merge json fields into one field ()
/**
 * 
 * @param {{
  name_en: "Computer",
  name_ar: "حاسوب",
  description_en: "This is English",
  description_ar: "هذا بالعربية",
  id: 1
}
  be :  
  {
  name: { en: "Computer", ar: "حاسوب" },
  description: { en: "This is English", ar: "هذا بالعربية" },
  id: 1
}

} flatRow 
 * @returns 
 */
function reconstructMultilingualFields(flatRow) {
  const result = {};

  for (const key in flatRow) {
    if (key.endsWith('_en') || key.endsWith('_ar')) {
      const base = key.slice(0, -3); // Remove _en or _ar
      const lang = key.endsWith('_en') ? 'en' : 'ar';

      if (!result[base]) result[base] = {};
      result[base][lang] = flatRow[key];
    } else {
      result[key] = flatRow[key];
    }
  }

  return result;
}

module.exports = {
    flattenMultilingualFields,
    reconstructMultilingualFields,
};