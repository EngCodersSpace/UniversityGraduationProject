'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class assignment extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      //(1)Relationship One-to-Many between "assignment table" and  "subject table"
      assignment.belongsTo(models.subject, {
        foreignKey: 'subject_id',//the foreign Key in the assignment table refers to subject table
      });

      //(2)Relationship One-to-Many between "assignment table" and  "doctor table"
      assignment.belongsTo(models.doctor, {
        foreignKey: 'doctor_id',//the foreign Key in the assignment table refers to doctor table
      });
      assignment.belongsToMany(models.student, {
        through: 'student_assignment',
        foreignKey: 'assignment_id',
      });

      assignment.hasMany(models.assignment_file, {
        foreignKey: 'assignment_id',
      });


    }
  }
  assignment.init({
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
    title: {
      type: DataTypes.JSON,
      allowNull: false,
    },
    assignment_due_day: {
      type: DataTypes.ENUM('Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'),
      allowNull: false,
    },
    assignment_date: {
      type: DataTypes.DATE,
      allowNull: false,
    },
    assignments_due_date: {
      type: DataTypes.DATE,
      allowNull: false,
    },



  }, {
    sequelize,
    modelName: 'assignment',
  });
  return assignment;
};