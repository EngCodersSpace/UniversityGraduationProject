'use strict';
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


  }, {
    sequelize,
    modelName: 'assignment_attachment',
    timestamps: false,
    indexes: [
      {
        unique: true,
        fields: ['assignment_id', 'attachment'],
      },
    ],
  });
  return assignment_attachment;
};