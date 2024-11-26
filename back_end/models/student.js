'use strict';
const {
  Model
} = require('sequelize');
const { default: ModelManager } = require('sequelize/lib/model-manager');
module.exports = (sequelize, DataTypes) => {
  class student extends Model {
   
    static associate(models) {
      
      student.belongsTo(models.user, {
        foreignKey: 'student_id',//the foreign Key in the student table refers to user table
        targetKey: 'user_id',     //the pwimary Key in the user
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


    }
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
  }, {
    sequelize,
    modelName: 'student',

    defaultScope: {
      attributes: { exclude: ['study_plan_id', 'student_section_id', 'student_level_id'] },
      include: [
        // {
        //   model: sequelize.models.study_plan,
        //   as: 'study_plan',
        // },
        {
          model: sequelize.models.section,
          as: 'section',
        },
        {
          model: sequelize.models.level,
          as: 'level',
        }
      ],
    },


  });


  student.prototype.getFullData = function () {
    const student = this.toJSON();
        if (this.user) {
          return { ...this.user, ...student };
        }
        return student;
  };
  return student;
};
