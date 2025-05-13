'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class assignment_file extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      assignment_file.belongsTo(models.assignment, {
        foreignKey: 'assignment_id',
      });
    }
  }
  assignment_file.init({

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
    attachment_hash: {
      type: DataTypes.STRING(64),
      allowNull: false,
    },
    original_name: {
      type: DataTypes.STRING,
      allowNull: false
    },


  }, {
    sequelize,
    modelName: 'assignment_file',
    timestamps: false,    
  });
  return assignment_file;
};