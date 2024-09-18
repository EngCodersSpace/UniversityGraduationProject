'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class phone_number extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  phone_number.init({

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
    phone_number: {
      type: DataTypes.STRING,
      allowNull: false,
      unique:true,
    },

    phone_number: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'phone_number',
  });
  return phone_number;
};