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
    //  */
    // static associate(models) {
    //   // define association here

    //   //(1)Relationship One-to-Many between "phone_number table"  and  "user table"
    //   phone_number.belongsTo(models.user,{
    //     foreignKey: 'user_id',//the foreign Key in the phone_number table refers to user table
    //     targetKey:'user_id',  //the pwimary Key in the user 
    //     //the child table does not make changes to the parent , so we don't need the instructions => "onDelete"&"onUpdate"
    //     // onDelete:'NO ACTION', //if a phone_number is deleted the user associated with him will not be deleted
    //     // onUpdate:'NO ACTION', //if a phone_number is update the user associated with him will not be updated
    //   });

    };
  
  phone_number.init({

    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    user_id: {
      type: DataTypes.INTEGER,
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
    timestamps:false,
  });
  return phone_number;
};