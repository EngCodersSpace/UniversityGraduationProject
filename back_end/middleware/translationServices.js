const { default: translate } = require('translate');
const { translation } = require('../models'); 
// const { translateText } = require('translator');
// const translator = require('google-translator');





// async function addTranslation(tableName, recordId, field, value, language) {
//   try {

    
//     await translation.create({
//       tableName,
//       recordId,
//       field,
//       value,
//       language,
//     });

//     // translate.engine='google';
//     const targetLanguage = language === 'ar' ? 'en' : 'ar';
//     const translatedValue = await translate(value, targetLanguage);

//     await translation.create({
//       tableName,
//       recordId,
//       field,
//       value: translatedValue,
//       language: targetLanguage,
//     });

    
//   } catch (error) {
//     throw new Error(`Error adding translation ${error.message}`);
//   }
// }

async function addTranslation(tableName, recordId, field, value, language) {
  try {
    if (language === 'ar') {
      await translation.create({
        tableName,
        recordId,
        field,
        value,
        language,
      });
    }
  } catch (error) {
    throw new Error(Error `addingtranslation: ${error.message}`);
  }
}


async function getTranslation(tableName, recordId, field, language) {
  try {
    const translationRecord = await translation.findOne({
      where: { tableName, recordId, field, language },
    });

    return translationRecord ? translationRecord.value : null;
  } catch (error) {
    throw new Error('Error fetching translation');
  }
}

async function updateTranslation(tableName, recordId, field, value, language) {
  try {
    await translation.update(
      { value },
      { where: { tableName, recordId, field, language } }
    );

    const targetLanguage = language === 'ar' ? 'en' : 'ar';
    const translatedValue = await translateText(value, targetLanguage);

    await translation.update(
      { value: translatedValue },
      { where: { tableName, recordId, field, language: targetLanguage } }
    );
  } catch (error) {
    throw new Error('Error updating translation');
  }
}

module.exports = {
  addTranslation,
  getTranslation,
  updateTranslation
};





