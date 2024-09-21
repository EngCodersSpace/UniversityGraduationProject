'use strict';
const {
  Model
} = require('sequelize');
const { default: ModelManager } = require('sequelize/lib/model-manager');
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
      student.belongsTo(models.user, {
        foreignKey: 'student_id',//the foreign Key in the student table refers to user table
        targetKey: 'user_id',     //the pwimary Key in the user
        //the child table does not make changes to the parent , so we don't need the instructions => "onDelete"&"onUpdate" 
        // onDelete:'NO ACTION',    //if a student is deleted the user associated with him will not be deleted
        // onUpdate:'NO ACTION',    //if a student is update the user associated with him will not be updated
      });

      //(2)Relationship One-to-Many between "student table" and  "study_plan table"
      student.belongsTo(models.study_plan, {
        foreignKey: 'study_plan_id',//the foreign Key in the student table refers to study_plan table
      });
      //(3)Relationship One-to-Many between "student table" and  "grade table"
      student.hasMany(models.grade,{
        foreignKey:'student_id',//the foreign Key in the grade table refers to student table
      });

    }//study_plan
  }
  student.init({

    student_id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      references: {
        model: 'users',
        key: 'user_id',
      },
      onDelete: 'CASCADE',//if a user is delete the student associated with him will be deleted
      onUpdate: 'CASCADE',//if a user is update the student associated with him will be updated
    },
    study_plan_id: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: 'study_plans',
        key: 'study_plan_id',
      },
      onDelete: 'SET NULL',//if a study_plan is delete the student associated with him will be set null in the study_plan_id
      onUpdate: 'CASCADE',//if a study_plan is update the student associated with him will be updated
    },
  
    student_name: {
      type: DataTypes.STRING,
      allowNull:false,
    },
    student_section: {
      type: DataTypes.ENUM('Computer', 'Communications', 'Civil', 'Architecture'),
      allowNull:false,
    },
    enrollment_year: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    student_level: {
      type: DataTypes.ENUM('Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5',),
      allowNull: false,
    },
    status: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    profile_picture:{
      type:DataTypes.STRING,
      allowNull:true,
    },


  }, {
    sequelize,
    modelName: 'students',
  });
  return student;
};