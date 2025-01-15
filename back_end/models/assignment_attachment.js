'use strict';
const crypto = require('crypto');
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class assignment_attachment extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      assignment_attachment.belongsTo(models.assignment, {
        foreignKey: 'assignment_id',
      });
    }
  }
  assignment_attachment.init({

    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },

    assignment_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'assignments',
        key: 'id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    attachment: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    attachment_hash:{
      type:DataTypes.STRING(64),
      allowNull:false,
    }


  }, {
    sequelize,
    modelName: 'assignment_attachment',
    timestamps: false,
    indexes: [
      {
        unique: true,
        fields: ['assignment_id', 'attachment_hash'],
      },
    ],
    hooks:{
      beforeValidate:(record)=>{
        record.attachment_hash=crypto.createHash('sha256').update(record.attachment).digest('hex');
      },
    },
  });
  return assignment_attachment;
};