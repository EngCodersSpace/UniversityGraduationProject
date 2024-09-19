'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class study_plan extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      //(1)Relationship One-to-Many between "study_plan table" and  "student table"
      study_plan.hasMany(models.student, {
        foreignKey: 'study_plan_id', //the foreign Key in the student table refers to study_plan table
      });
    }
  }
  study_plan.init({

    study_plan_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
    },
    study_plan_name: {
      type: DataTypes.STRING,
      allowNull: false,
    },

  }, {
    sequelize,
    modelName: 'study_plan',
  });
  return study_plan;
};