'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class notification extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here

      //(1)Relationship One-to-Many between "notification table" and  "user table"
      notification.belongsTo(models.user, {
        foreignKey: 'sender_id',
        targetKey: 'user_id',

      });

    }
  }
  notification.init({


    message_id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    sender_id: {
      type: DataTypes.INTEGER,
      references: {
        model: 'users',
        key: 'user_id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    title: {
      type: DataTypes.STRING(100)
    },
    message: {
      type: DataTypes.TEXT,
      allowNull:false,
    },
    is_read:{
      type:DataTypes.BOOLEAN,
      defaultValue:false
    },
    type:{
      type:DataTypes.ENUM('System','Reminder','Alert'),
      defaultValue:'System',
    },

  }, {
    sequelize,
    modelName: 'notification',
  });
  return notification;
};