// const { default: translate } = require('translate');
// const { translation } = require('../models'); 
// const { translateText } = require('translator');
// const translator = require('google-translator');


// const translateTex = require('translate-google');


// function translateText(anystring, fromLang, toLang) {
//     return translateTex(anystring, { from: fromLang, to: toLang });
// }

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


// middleware/translationServices
const translateTex = require('translate-google');

async function translateText(anystring, fromLang, toLang) {
  try {
    const translatedValue = await translateTex(`${anystring}`, { from: `${fromLang}`, to: `${toLang}` });
    return translatedValue; 
  } catch (error) {
    throw new Error(`Translation error: ${error.message}`);
  }
}

const detectLanguage = (req, res, next) => {
  req.language = req.headers['accept-language']?.startsWith('ar') ? 'ar' : 'en';
  next();
};

const translateResponse = (req, res, next) => {
  const originalSend = res.send;
  
  res.send = function (data) {
    if (typeof data === 'object' && req.language) {
      data = translateObject(data, req.language);
    }
    originalSend.call(this, data);
  };
  
  next();
};

async function translateObject(obj, targetLanguage) {
  const sourceLanguage = targetLanguage === 'ar' ? 'en' : 'ar';
  const result = {};
  
  for (const [key, value] of Object.entries(obj)) {
    if (typeof value === 'string') {
      try {
        result[key] = await translateText(value, sourceLanguage, targetLanguage);
      } catch (error) {
        result[key] = value;
      }
    } else {
      result[key] = value;
    }
  }
  
  return result;
}

module.exports = { 
  translateText, 
  detectLanguage, 
  translateResponse 
};
