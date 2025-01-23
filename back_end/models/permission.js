'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class permission extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      permission.belongsToMany(models.role, {
        through: 'role_permission',
        foreignKey: 'permissionId'
      });
    }
  }
  permission.init({
    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    target: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    action: {
      type: DataTypes.STRING,
      allowNull: false,
    },


  }, {
    sequelize,
    modelName: 'permission',
    indexes: [
      {
        unique: true,
        fields: ['target', 'action'],
        name: 'unique_constraint_in_permissions',
      },
    ],
  });
  return permission;
};