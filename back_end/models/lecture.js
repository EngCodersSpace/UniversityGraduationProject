'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class lecture extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here

      //(1)Relationship One-to-Many between "lecture table" and  "subject table"
      lecture.belongsTo(models.subject, {
        foreignKey: 'subject_id',//the foreign Key in the lecture table refers to subject table
      });

      //(2)Relationship One-to-Many between "lecture table" and  "doctor table"
      lecture.belongsTo(models.doctor, {
        foreignKey: 'doctor_id',//the foreign Key in the lecture table refers to doctor table
      });

      //(3)Relationship One-to-Many between "lecture table" and  "section table"
      lecture.belongsTo(models.section, {
        foreignKey: 'lecture_section_id',//the foreign Key in the lecture table refers to section table
      });

      //(4)Relationship One-to-Many between "lecture table" and  "level table"
      lecture.belongsTo(models.level, {
        foreignKey: 'lecture_level_id',//the foreign Key in the lecture table refers to level table
      });


    }
  }
  lecture.init({

    id: {
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
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    doctor_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'doctors',
        key: 'doctor_id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    lecture_section_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'sections',
        key: 'id',
      },
      onDelete: 'NO ACTION',
      onUpdate: 'CASCADE',
    },
    lecture_level_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'levels',
        key: 'id',
      },
      onDelete: 'NO ACTION',
      onUpdate: 'CASCADE',
    },
    term: {
      type: DataTypes.ENUM('Term 1', 'Term 2'),
      allowNull: false,
    },
    year: {
      type: DataTypes.STRING(30),
      allowNull: false,
    },
    lecture_time: {
      type: DataTypes.TIME,
      allowNull: false,
    },
    lecture_duration: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },
    lecture_day: {
      type: DataTypes.ENUM('Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'),
      allowNull: false,
    },
    lecture_room: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },


  }, {
    sequelize,
    modelName: 'lecture',
    indexes: [
      {
        unique: true,
        fields: ['lecture_time', 'lecture_day', 'lecture_section_id', 'lecture_room'],
        name: 'unique_constraint_in_lecture',

      },
    ],
  });
  return lecture;
};