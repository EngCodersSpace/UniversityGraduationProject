'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class paper_form_forward_step extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      paper_form_forward_step.belongsTo(models.paper_form_type, {
        foreignKey: 'form_type_id',
      });

      paper_form_forward_step.belongsTo(models.user, {
        foreignKey: 'user_id',
      });
    }
  }
  paper_form_forward_step.init({
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
    step_order:{
      type:DataTypes.INTEGER,
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
    is_final_step:{
      type:DataTypes.BOOLEAN,
      allowNull:false,
      defaultValue:false,
    },
    not:{
      type:DataTypes.TEXT,
      allowNull:true,
    },
  }, {
    sequelize,
    modelName: 'paper_form_forward_step',
  });
  return paper_form_forward_step;
};