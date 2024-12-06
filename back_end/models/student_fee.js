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

      //(2)Relationship One-to-Many between "student_fee table" and  "section table"
      student_fee.belongsTo(models.section, {
        foreignKey: 'section_id',//the foreign Key in the student_fee table refers to section table
      });

      //(3)Relationship One-to-Many between "student_fee table" and  "level table"
      student_fee.belongsTo(models.section, {
        foreignKey: 'level_fees_id',//the foreign Key in the student_fee table refers to level table
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
    section_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'sections',
        key: 'id',
      },
      onDelete: 'NO ACTION',
      onUpdate: 'CASCADE',
    },

    level_fees_id: {
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
    // payment_status: {
    //   type: DataTypes.ENUM('Paid', 'Unpaid', 'Remaining'),
    //   allowNull: false,
    // },
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