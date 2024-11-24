'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class section extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here

      //(1) Relationship One-to-Many between "student table" and  "section table"
      section.hasMany(models.student, {
        foreignKey: 'student_section_id',
      });

      //(2) Relationship One-to-Many between "student table" and  "section table"
      section.hasMany(models.study_plan_elment, {
        foreignKey: 'section_id',
      });


    }
  }
  section.init({

    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    section_name: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },


  }, {
    sequelize,
    modelName: 'section',
  });
  return section;
};