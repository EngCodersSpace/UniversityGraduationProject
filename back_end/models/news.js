'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class news extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here

      news.belongsTo(models.user, {
        foreignKey: 'publisher_id',  
      });

    }
  }
  news.init({

    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    publisher_id: {
      type: DataTypes.INTEGER,
      allowNull:false,
      references: {
        model: 'users' ,
        key:'user_id',
      },
      onDelete:'NO ACTION',
      onUpdate:'CASCADE',  
    },
    title:{
      type:DataTypes.STRING,
      allowNull:false,
    },
    content:{
      type:DataTypes.TEXT,
      allowNull:false,
    },
    time:{
      type: DataTypes.DATEONLY,
      allowNull: false,
      defaultValue: DataTypes.NOW,
    },
    image:{
      type:DataTypes.STRING,
      allowNull:true,
    },

    
  }, {
    sequelize,
    modelName: 'news',
  });
  return news;
};      