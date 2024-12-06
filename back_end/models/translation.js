'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class translation extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      //(1)Relationship One-to-Many between "language table" and  "translation"
      translation.belongsTo(models.language, {
        foreignKey: 'languageId',//the foreign Key in the lecture table refers to subject table
      });
    }
  }
  translation.init({
    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    tableName: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    recordId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    field: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    languageId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references:{
        model:'languages',
        key:'id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    value: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
  }, {
    sequelize,
    modelName: 'translation',
    indexes:[
      {
      unique:false,
      fields:['tableName','recordId','field','languageId'],
      },    
    ],
  });
  return translation;
};