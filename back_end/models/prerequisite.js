'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class prerequisite extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here

      //(1)Relationship One-to-Many between "prerequisite table" and  "subject table"
      prerequisite.belongsTo(models.subject, {
        foreignKey: 'subject_id',
      });

      //(2)Relationship One-to-Many between "prerequisite table" and  "study_plan_elment table"
      prerequisite.belongsTo(models.study_plan_elment, {
        foreignKey: 'study_plan_elment_id',
      });

    }
  }
  prerequisite.init({

    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
    },
    subject_id: {
      type: DataTypes.STRING(10),
      allowNull: true,
      references: {
        model: 'subjects',
        key: 'subject_id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    study_plan_elment_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'study_plan_elments',
        key: 'study_plan_elment_id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },

  }, {
    sequelize,
    modelName: 'prerequisite',
    timestamps: false,
    indexes: [
      {
        unique: true,
        fields: ['study_plan_elment_id', 'subject_id'],
        name: 'unique_constraint_in_study_plan_elment_id_and_subject_id',
      },
    ],
  });
  return prerequisite;
};