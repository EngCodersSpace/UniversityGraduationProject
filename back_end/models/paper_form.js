'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class paper_form extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      paper_form.belongsTo(models.paper_form_type, {
        foreignKey: 'form_type_id',
      });

      paper_form.belongsTo(models.user, {
        foreignKey: 'user_id',
      });

      paper_form.belongsTo(models.user, {
        foreignKey: 'current_user_id',
      });
      paper_form.hasMany(models.paper_form_activitie, {
        foreignKey: 'form_id',
      });


    }
  }
  paper_form.init({
    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    form_type_id: {
      type: DataTypes.INTEGER,
      references: {
        model: 'paper_form_types',
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
    form_data: {
      type: DataTypes.JSON,
    },
    status: {
      type: DataTypes.ENUM('pending', 'approved', 'rejected', 'cancelled')
    },
    current_user_id: {
      type: DataTypes.INTEGER,
      references: {
        model: 'users',
        key: 'user_id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
    current_step: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 1,
    },
  }, {
    sequelize,
    modelName: 'paper_form',
  });
  return paper_form;
};