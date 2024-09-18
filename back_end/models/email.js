'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class email extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  email.init({

    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    user_id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      references: {
        model: 'users' ,
        key:'user_id',
      },
      onDelete:'CASCADE',
      onUpdate:'CASCADE',  
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique:true,
      validate:{isEmail:true,},
    },

    email: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'email',
  });
  return email;
};