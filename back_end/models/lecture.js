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
    lecture_section: {
      type: DataTypes.ENUM('Computer', 'Communications', 'Civil', 'Architecture'),
      allowNull: false,
    },
    lecture_level: {
      type: DataTypes.ENUM('Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5',),
      allowNull: false,
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
        fields: ['lecture_time', 'lecture_day', 'lecture_section', 'lecture_room'],
        name: 'unique_constraint_in_lecture',

      },
    ],
  });
  return lecture;
};