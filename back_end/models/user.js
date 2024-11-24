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
      user.hasOne(models.student, {
        foreignKey: 'student_id', //the foreign Key in the student table refers to user table
        sourceKey: 'user_id',     //the primary key in the user table
        //onDelete:'CASCADE',      //if a user is delete the student associated with him will be deleted 
        //onUpdate:'CASCADE',      //if a user is update the student associated with him will be updated
      });

      //(2)Relationship One-to-Many between "user table" and  "phone_number table"
      user.hasMany(models.phone_number, {
        foreignKey: 'user_id',
        sourceKey: 'user_id',
        // onDelete:'CASCADE',
        // onUpdate:'CASCADE',
      });

      //(3)Relationship One-to-One between "user table" and  "doctor table"
      user.hasOne(models.doctor, {
        foreignKey: 'doctor_id', //the foreign Key in the doctor table refers to user table
        sourceKey: 'user_id',     //the primary key in the user table
        // onDelete:'CASCADE',      //if a user is delete the doctor associated with him will be deleted 
        // onUpdate:'CASCADE',      //if a user is update the doctor associated with him will be updated
      });

      //(4)Relationship One-to-Many between "user table" and  "notification table"
      user.hasMany(models.notification, {
        foreignKey: 'sender_id',
        sourceKey: 'user_id',
      });

      //(5)Relationship One-to-Many between "user table" and  "document"
      user.hasMany(models.document, {
        foreignKey: 'added_by',
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
    profile_picture: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    collegeName: {
      type: DataTypes.STRING(50),
      allowNull: false,
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
      set(value) {
        const hasedpassword = bcrypt.hashSync(value, 10);
        this.setDataValue('password', hasedpassword);
      },
    },
    resetToken: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    resetTokenExpiry: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    refreshToken: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    fullDataDoctor: {
      type: DataTypes.VIRTUAL,
      get() {
        const user = this.toJSON();
        if (this.doctor) {
          return { ...user, ...this.doctor };
        }
        return user;
      }
    },
    fullDataStudent: {
      type: DataTypes.VIRTUAL,
      get() {
        const user = this.toJSON();
        if (this.student) {
          return { ...user, ...this.student };
        }
        return user;
      }
    },



  }, {
    sequelize,
    modelName: 'user',

    defaultScope: {
      attributes: { exclude: ['password', 'createdAt', 'updatedAt'] },
    },

    scopes: {
      with_hidden_data: {
        attributes: { include: ['password', 'createdAt', 'updatedAt'] },
      },
    },


  });

  return user;

};

