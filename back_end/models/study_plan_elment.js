'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class study_plan_elment extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here

       //(1)Relationship One-to-Many between "study_plan_elment table" and  "study_plan table"
       study_plan_elment.belongsTo(models.study_plan, {
        foreignKey: 'study_plan_id',//the foreign Key in the study_plan_elment table refers to study_plan table
      });

       //(2)Relationship One-to-Many between "study_plan_elment table" and  "subject table"
       study_plan_elment.belongsTo(models.subject, {
        foreignKey: 'subject_id',//the foreign Key in the study_plan_elment table refers to subject table
      });

       //(3)Relationship One-to-Many between "study_plan_elment table" and  "doctor table"
       study_plan_elment.belongsTo(models.doctor, {
        foreignKey: 'doctor_id',//the foreign Key in the study_plan_elment table refers to doctor table
      });

      //(4)Relationship One-to-Many between "study_plan_elment table" and  "prerequisite table"
      study_plan_elment.hasMany(models.prerequisite,{
        foreignKey:'study_plan_elment_id',
      });


    }
  }
  study_plan_elment.init({


    study_plan_elment_id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    study_plan_id: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: 'study_plans',
        key: 'study_plan_id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    subject_id: {
      type: DataTypes.STRING(10),
      allowNull: false,
      references: {
        model: 'subjects',
        key: 'subject_id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    doctor_id: {
      type: DataTypes.INTEGER,
      allowNull:true,
      references: {
        model: 'doctors' ,
        key:'doctor_id',
      },
      onDelete:'SET NULL',
      onUpdate:'CASCADE',  
    },
    section: {
      type: DataTypes.ENUM('Computer', 'Communications', 'Civil', 'Architecture'),
      allowNull: false,
    },
    level: {
      type: DataTypes.ENUM('Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5',),
      allowNull: false,
    },
    number_of_units: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    term: {
      type: DataTypes.ENUM('Term 1', 'Term 2'),
      allowNull: false,
    },

  }, {
    sequelize,
    modelName: 'study_plan_elment',
  });
  return study_plan_elment;
};