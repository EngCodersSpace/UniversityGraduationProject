'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class student extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      
      //(1)Relationship One-to-One between "student table" and  "user table"
      student.belongsTo(models.user,{foreignKey: 'student_id'});


    }
  }
  student.init({
    

    student_id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      references: {
        model:'users',
        key:'user_id',
      },
      
    },
    student_name: {
      type: DataTypes.STRING,
    },
    student_section: {
      type: DataTypes.STRING,
      validate:{
        isIn:[['Computer','Communications','Civil','Architecture']],},
    },
    enrollment_year: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    student_level: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    status: {
      type: DataTypes.STRING,
      allowNull: false,

    },
    address: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    gender: {
      type: DataTypes.STRING,
      allowNull: false,
      validate:{
        isIn:[['Male','Female']],},
      
    },

  }, {
    sequelize,
    modelName: 'student',
  });
  return student;
};