'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class documentSectionLevel extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  documentSectionLevel.init({
    documentId:{
      type:DataTypes.INTEGER,
      allowNull:false,
      primaryKey:true,
      references:{
        model:'documents',
        key:'id',
      },
      onDelete: 'NO ACTION',
      onUpdate: 'CASCADE',
    },
    sectionId:{
      type:DataTypes.INTEGER,
      allowNull:false,
      references:{
        model:'sections',
        key:'id',
      },
      onDelete: 'NO ACTION',
      onUpdate: 'CASCADE',
    },
    levelId:{
      type:DataTypes.INTEGER,
      allowNull:false,
      references:{
        model:'levels',
        key:'id',
      },
      onDelete: 'NO ACTION',
      onUpdate: 'CASCADE',
    },
  }, {
    sequelize,
    modelName: 'documentSectionLevel',
    timestamps:false,
  });
  return documentSectionLevel;
};