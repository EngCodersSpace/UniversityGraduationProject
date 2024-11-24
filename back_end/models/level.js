'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class level extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here

      //(1) Relationship One-to-Many between "student table" and  "level table"
      level.hasMany(models.student,{
        foreignKey:'student_level_id',
      });

      //(2) Relationship One-to-Many between "study_plan_elment table" and  "level table"
      level.hasMany(models.study_plan_elment,{
        foreignKey:'level_id',
      });      

      //(3) Relationship One-to-Many between "student_fee table" and  "level table"
      level.hasMany(models.student_fee,{
        foreignKey:'level_fees_id',
      });            


    }
  }
  level.init({

    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    level_name: {
      type:DataTypes.STRING(50),
      allowNull:false,
    },


  }, {
    sequelize,
    modelName: 'level',
  });
  return level;
};