'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class student_fee extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here

      //(1)Relationship One-to-Many between "student_fee table" and  "student table"
      student_fee.belongsTo(models.student, {
        foreignKey: 'student_id',//the foreign Key in the student_fee table refers to student table
      });


    }
  }
  student_fee.init({

    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    student_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'students',
        key: 'student_id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    level_fees: {
      type: DataTypes.ENUM('Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5',),
      allowNull: false,
    },
    term: {
      type: DataTypes.ENUM('Term 1', 'Term 2'),
      allowNull: false,
    },
    section: {
      type: DataTypes.ENUM('Computer', 'Communications', 'Civil', 'Architecture'),
      allowNull: false,
    },
    total_amount: {
      type: DataTypes.DECIMAL(8, 2),
      allowNull: false,
    },
    amount_paid: {
      type: DataTypes.DECIMAL(8, 2),
      allowNull: false,
    },
    remaining_amount: {
      type: DataTypes.DECIMAL(8, 2),
      allowNull: false,
    },
    payment_status: {
      type: DataTypes.ENUM('Paid', 'Unpaid', 'Remaining'),
      allowNull: false,
    },
    payment_date: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    receipt_number: {
      type: DataTypes.STRING,
      allowNull: false,
    },


  }, {
    sequelize,
    modelName: 'student_fee',
  });
  return student_fee;
};