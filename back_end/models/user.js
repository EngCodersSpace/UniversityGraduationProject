'use strict';
const bcrypt = require('bcrypt');
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
      user.hasOne(models.student,{
        foreignKey:'student_id',
        sourceKey:'user_id',
        onDelete:'CASCADE',
        onUpdate:'CASCADE',
      });

      // //(2)Relationship One-to-Many between "user table" and  "email table"
      // user.hasMany(models.email,{
      //   foreignKey:'user_id',
      //   sourceKey:'user_id',
      //   onDelete:'CASCADE',
      //   onUpdate:'CASCADE',
      // })


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
    date_of_birth: {
      type: DataTypes.DATE,
      allowNull: false,
    },
    permission: {
      type: DataTypes.ENUM('student', 'teacher', 'admin', 'staff'),
      allowNull: false,
      defaultValue: 'student',
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
      set(value){
        const hasedpassword = bcrypt.hashSync(value,10);
        this.setDataValue('password',hasedpassword);
      },
    },

    
  }, {
    sequelize,
    modelName: 'user',
  });

  return user;

};

