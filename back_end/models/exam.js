'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class exam extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here

      //(1)Relationship One-to-Many between "exam table" and  "subject table"
      exam.belongsTo(models.subject, {
        foreignKey: 'subject_id',//the foreign Key in the exam table refers to subject table
      });

    }
  }
  exam.init({

    exam_id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
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
    exam_section: {
      type: DataTypes.ENUM('Computer', 'Communications', 'Civil', 'Architecture'),
      allowNull: false,
    },
    exam_level: {
      type: DataTypes.ENUM('Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5',),
      allowNull: false,
    },
    exam_term: {
      type: DataTypes.ENUM('Term 1', 'Term 2'),
      allowNull: false,
    },
    exam_year: {
      type: DataTypes.STRING(30),
      allowNull: false,
    },
    exam_date: {
      type: DataTypes.DATEONLY,
      allowNull: false,
    },
    exam_time: {
      type: DataTypes.TIME,
      allowNull: false,
    },
    exam_day: {
      type: DataTypes.ENUM('Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'),
      allowNull: false,
    },
    exam_room: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },

  }, {
    sequelize,
    modelName: 'exam',
    indexes: [
      {
        unique: true,
        fields: ['exam_section', 'exam_level', 'exam_term', 'exam_year', 'exam_date', 'exam_time', 'exam_day'],
        name: 'unique_constraint_in_exam',
      },
    ],
  });
  return exam;
};



