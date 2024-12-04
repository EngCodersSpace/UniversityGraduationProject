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
        type: DataTypes.STRING,
        allowNull: false,
      },
      recordId: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      field: {
        type: DataTypes.STRING,
        allowNull:false,
      },
      language:{
        type:DataTypes.INTEGER,
        allowNull:false,
      },
      value:{
        type:DataTypes.STRING,
        allowNull:false,
      },
  }, {
    sequelize,
    modelName: 'translation',
  });
  return translation;
};