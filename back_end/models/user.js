'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class user extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      
     //(1)Relationship One-to-One between "user table" and  "student table"
     user.hasOne(models.student,{foreignKey:'student_id'});
      
    }
  }
  user.init({


    
    user_id: {
      type: DataTypes.INTEGER,
      primaryKey: true,

    },

    user_name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
  
    date_of_pirth: {
      type: DataTypes.DATE,
      allowNull: false,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique:true,
      validate:{isEmail:true,},
    },
    phone_number: {
      type: DataTypes.INTEGER,
      allowNull: false,
      unique:true,
    },
    permission: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue:'student',
      validate:{
        isIn:[['student','teacher','admin','staff']],},
      },
      password: {
        type: DataTypes.STRING,
        allowNull: false,
        validate:{
          len: [8,100]},
      },
      description: {
        type: DataTypes.STRING,
        allowNull: true,
      },


  }, {
    sequelize,
    modelName: 'user',
  });
  return user;
};