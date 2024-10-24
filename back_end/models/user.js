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
        foreignKey:'student_id', //the foreign Key in the student table refers to user table
        sourceKey:'user_id',     //the primary key in the user table
       //onDelete:'CASCADE',      //if a user is delete the student associated with him will be deleted 
        //onUpdate:'CASCADE',      //if a user is update the student associated with him will be updated
      });

      //(2)Relationship One-to-Many between "user table" and  "phone_number table"
      user.hasMany(models.phone_number,{
        foreignKey:'user_id',
        sourceKey:'user_id',
        // onDelete:'CASCADE',
        // onUpdate:'CASCADE',
      });

      //(3)Relationship One-to-One between "user table" and  "doctor table"
      user.hasOne(models.doctor,{
        foreignKey:'doctor_id', //the foreign Key in the doctor table refers to user table
        sourceKey:'user_id',     //the primary key in the user table
        // onDelete:'CASCADE',      //if a user is delete the doctor associated with him will be deleted 
        // onUpdate:'CASCADE',      //if a user is update the doctor associated with him will be updated
      });


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
      allowNull: true,
    },
    email: {
      type: DataTypes.STRING(100),
      allowNull: false,
      unique: true,
      validate: { isEmail: true, },
    },
    permission: {
      type: DataTypes.ENUM('student', 'teacher', 'admin', 'staff'),
      allowNull: false,
      defaultValue: 'student',
    },
    password: {
      type: DataTypes.STRING(100),
      allowNull: false,
      set(value){
        const hasedpassword = bcrypt.hashSync(value,10);
        this.setDataValue('password',hasedpassword);
      },
    },
    reset_token:{
      type:DataTypes.STRING(100),
      allowNull:true,
    },
    reset_token_expiry:{
      type:DataTypes.DATE,
      allowNull:true,
    },
    

    
  }, {
    sequelize,
    modelName: 'user',
  });

  return user;

};

