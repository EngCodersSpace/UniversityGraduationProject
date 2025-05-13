'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class paper_form_type extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      paper_form_type.hasMany(models.paper_form, {
        foreignKey: 'form_type_id',
      });

      paper_form_type.hasMany(models.paper_form_forward_step, {
        foreignKey: 'form_type_id',
      });

    }
  }
  paper_form_type.init({
    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    name:{
      type:DataTypes.STRING,
      allowNull:false,
    },
    code:{
      type:DataTypes.STRING,
      allowNull:true,
    },
    description:{
      type:DataTypes.TEXT,
      allowNull:false,
    },
  }, {
    sequelize,
    modelName: 'paper_form_type',
  });
  return paper_form_type;
};