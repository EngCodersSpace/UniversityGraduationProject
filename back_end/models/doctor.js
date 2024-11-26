'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class doctor extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here

      //(1)Relationship One-to-One between "doctor table" and  "user table"
      doctor.belongsTo(models.user, {
        foreignKey: 'doctor_id',//the foreign Key in the doctor table refers to user table
        targetKey: 'user_id',     //the pwimary Key in the user
        as: 'user',
      });

      //(2)Relationship One-to-Many between "doctor table" and  "study_plan_elment table"
      doctor.hasMany(models.study_plan_elment,{
        foreignKey:'doctor_id',
      });


    }
  }
  doctor.init({

    doctor_id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      references: {
        model: 'users' ,
        key:'user_id',
      },
      onDelete:'CASCADE',
      onUpdate:'CASCADE',  
    },
    department: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    status: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    academic_degree: {
      type: DataTypes.ENUM('Doctor','Professor','Master','Bachelor'),
      allowNull: false,
    },
    administrative_position: {
      type: DataTypes.ENUM('Dean','Vice Dean','Lecturer','Department Chair','None'),
      defaultValue: 'None',
    },



  }, {
    sequelize,
    modelName: 'doctor',
  });
  return doctor;
};