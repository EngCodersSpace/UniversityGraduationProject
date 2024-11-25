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

       //(2)Relationship One-to-Many between "exam table" and  "section table"
       exam.belongsTo(models.section, {
        foreignKey: 'exam_section_id',//the foreign Key in the exam table refers to section table
      });

 //(3)Relationship One-to-Many between "exam table" and  "level table"
 exam.belongsTo(models.level, {
  foreignKey: 'exam_level_id',//the foreign Key in the exam table refers to level table
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
    exam_section_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'sections',
        key: 'id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    exam_level_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'levels',
        key: 'id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
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
        fields: ['exam_section_id', 'exam_level_id', 'exam_term', 'exam_year', 'exam_date', 'exam_time', 'exam_day'],
        name: 'unique_constraint_in_exam',
      },
    ],
  });
  return exam;
};