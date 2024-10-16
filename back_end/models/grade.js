'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class grade extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here

      //(1)Relationship One-to-Many between "grade table" and  "subject table"
      grade.belongsTo(models.subject, {
        foreignKey: 'subject_id',//the foreign Key in the grade table refers to subject table
      });

      //(2)Relationship One-to-Many between "grade table" and  "student table"
      grade.belongsTo(models.student, {
        foreignKey: 'student_id',//the foreign Key in the grade table refers to student table
      });

    }
  }
  grade.init({

    grad_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
    },
    student_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'students',
        key: 'student_id',
      },
      onDelete: 'CASCADE',//if a student is delete the grade associated with him will be deleted
      onUpdate: 'CASCADE',//if a student is update the grade associated with him will be updated
    },
    subject_id: {
      type: DataTypes.STRING(10),
      allowNull: false,
      references: {
        model: 'subjects',
        key: 'subject_id',
      },
      onDelete: 'NO ACTION',
      onUpdate: 'CASCADE',
    },
    exam_grade: {
      type: DataTypes.TINYINT,
      allowNull: true,
    },
    work_grade: {
      type: DataTypes.TINYINT,
      allowNull: true,
    },
    term: {
      type: DataTypes.ENUM('Term 1', 'Term 2'),
      allowNull: false,
    },
    section: {
      type: DataTypes.ENUM('Computer', 'Communications', 'Civil', 'Architecture'),
      allowNull: false,
    },
    level: {
      type: DataTypes.ENUM('Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5',),
      allowNull: false,
    },
    //Year the grade was issued
    year_of_issue: {
      type: DataTypes.DATEONLY,
      allowNull: false,
    },
    //Determine if the student is absent or not .[if "true '1' " =>(he is absent) , if "false '0' " =>(he is not absent)]
    is_absent: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },
    //Determine if the student has tested the subject before or not .[if "Repeater" =>(he is tested before) , if "Freshman" =>(he has never tested it before)]
    status: {
      type: DataTypes.ENUM('Freshman', 'Repeater'),
      allowNull: false,
      defaultValue: 'Freshman',
    },
    // //How many times did he retest the subject 
    // //Write a function to increase the value by +1  in every each time he retake the subject test
    // retake_count: {
    //   type: DataTypes.INTEGER,
    //   allowNull: false,
    //   defaultValue: 0,
    // },


  }, {
    sequelize,
    modelName: 'grade',
  });
  return grade;
};
