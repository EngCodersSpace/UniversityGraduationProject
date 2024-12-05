'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class language extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
        //(1)Relationship One-to-Many between "languag table" and  "translation table"
        language.hasMany(models.translation, {
          foreignKey: 'languageId', //the foreign Key in the translation table refers to subject table
        });
    }
  }
  language.init({
    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    languageName: {
      type:DataTypes.STRING(30),
      allowNull:false,
    },
  }, {
    sequelize,
    modelName: 'language',
  });
  return language;
};