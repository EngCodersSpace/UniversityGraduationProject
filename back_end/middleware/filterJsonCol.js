const { Sequelize,Op} = require('sequelize');


exports.filterJsonColumn = (columnName, lang, value) => {
    return Sequelize.where(
      Sequelize.literal(`JSON_UNQUOTE(JSON_EXTRACT(${columnName}, '$.${lang}'))`),
      { [Op.like]: `%${value}%` }
    );
};