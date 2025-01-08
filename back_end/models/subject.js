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

      //(1)Relationship One-to-Many between "subject table" and  "study_plan_elment table"
      subject.hasMany(models.study_plan_elment, {
        foreignKey: 'subject_id', //the foreign Key in the study_plan_elment table refers to subject table
      });

      //(2)Relationship One-to-Many between "subject table" and  "grade table"
      subject.hasMany(models.grade, {
        foreignKey: 'subject_id', //the foreign Key in the grade table refers to subject table
      });

      //(3)Relationship One-to-Many between "subject table" and  "prerequisite table"
      subject.hasMany(models.prerequisite, {
        foreignKey: 'subject_id', //the foreign Key in the prerequisite table refers to subject table
      });

      //(4)Relationship One-to-Many between "subject table" and  "exam table"
      subject.hasMany(models.exam, {
        foreignKey: 'subject_id', //the foreign Key in the exam table refers to subject table
      });

      //(5)Relationship One-to-Many between "subject table" and  "book"
      subject.hasMany(models.book, {
        foreignKey: 'subject_id', //the foreign Key in the book table refers to subject table
      });

      subject.belongsToMany(models.doctor, {
        through: 'subject_teacher',
        foreignKey: 'subject_id',
      });

      subject.hasMany(models.assignment, {
        foreignKey: 'subject_id',
      });


    }
  }
  subject.init({

    subject_id: {
      allowNull: false,
      primaryKey: true,
      type: DataTypes.STRING(10),
    },
    subject_name: {
      type: DataTypes.JSON,
      allowNull: false,
    },
    number_of_units: {
      type: DataTypes.TINYINT,
      allowNull: false,
    },
    subject_description: {
      type: DataTypes.JSON,
      allowNull: false,
    },
  }, {
    sequelize,
    modelName: 'subject',
  });
  return subject;
};