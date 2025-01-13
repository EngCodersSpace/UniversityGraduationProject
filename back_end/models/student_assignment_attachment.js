'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class student_assignment_attachment extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      student_assignment_attachment.belongsTo(models.student_assignment, {
        foreignKey: 'student_assignment_id',
      });
    }
  }
  student_assignment_attachment.init({
    student_assignment_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'studstudent_assignmentsents',
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
    modelName: 'student_assignment_attachment',
    timestamps: false,
    indexes: [
      {
        unique: true,
        fields: ['student_assignment_id', 'attachment'],
      },
    ],
  });
  return student_assignment_attachment;
};