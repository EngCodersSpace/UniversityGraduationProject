'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class subject extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here

      //(1)Relationship One-to-Many between "subject table" and  "study_plan_description table"
      subject.hasMany(models.study_plan_description, {
        foreignKey: 'subject_id', //the foreign Key in the study_plan_description table refers to subject table
      });

      //(2)Relationship One-to-Many between "subject table" and  "grade table"
      subject.hasMany(models.grade, {
        foreignKey: 'subject_id', //the foreign Key in the grade table refers to subject table
      });

    }
  }
  subject.init({

    subject_id: {
      allowNull: false,
      primaryKey: true,
      type: DataTypes.STRING,
    },
    subject_name: {
      type: DataTypes.STRING
    },
    number_of_units:{
      type:DataTypes.INTEGER,
      allowNull:false,
    },
    subject_description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
  }, {
    sequelize,
    modelName: 'subject',
  });
  return subject;
};