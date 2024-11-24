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
      student.hasMany(models.grade, {
        foreignKey: 'student_id',//the foreign Key in the grade table refers to student table
      });

      //(4)Relationship One-to-Many between "student table" and  "student_fee table"
      student.hasMany(models.student_fee, {
        foreignKey: 'student_id',//the foreign Key in the student_fee table refers to student table
      });

      //(5)Relationship One-to-Many between "student table" and  "level table"
      student.belongsTo(models.level, {
        foreignKey: 'student_level_id',//the foreign Key in the student table refers to level table
      });

      //(6)Relationship One-to-Many between "student table" and  "section table"
      student.belongsTo(models.section, {
        foreignKey: 'student_section_id',//the foreign Key in the student table refers to section table
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
    student_section_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'sections',
        key: 'id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    student_level_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'levels',
        key: 'id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    enrollment_year: {
      type: DataTypes.DATEONLY,
      allowNull: false,
    },

    student_system: {
      type: DataTypes.ENUM('General', 'Free Seat', 'Paid'),
      allowNull: false,
    },
    profile_picture: {
      type: DataTypes.STRING,
      allowNull: true,
    },


  }, {
    sequelize,
    modelName: 'student',
  });
  return student;
};