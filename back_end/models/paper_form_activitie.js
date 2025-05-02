'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class paper_form_activitie extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      paper_form_activitie.belongsTo(models.paper_form, {
        foreignKey: 'form_id',
      });

      paper_form_activitie.belongsTo(models.user, {
        foreignKey: 'user_id',
      });
    }
  }
  paper_form_activitie.init({
    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    form_id: {
      type: DataTypes.INTEGER,
      references: {
        model: 'paper_forms',
        key: 'id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    user_id: {
      type: DataTypes.INTEGER,
      references: {
        model: 'users',
        key: 'user_id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    action: {
      type: Sequelize.ENUM('approved', 'rejected', 'commented'),
    },
    comment: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
  }, {
    sequelize,
    modelName: 'paper_form_activitie',
  });
  return paper_form_activitie;
};