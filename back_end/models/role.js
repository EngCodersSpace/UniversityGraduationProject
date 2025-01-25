'use strict';
const { ro } = require('@faker-js/faker');
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class role extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      role.belongsToMany(models.permission, {
        through: 'role_permission',
        foreignKey: 'roleId'
      });

      role.hasMany(models.user, {
        foreignKey: 'roleId',
      });

      // role.hasMany(models.role_permission, {
      //   foreignKey: 'roleId',
      // });


    }
  }
  role.init({
    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },

    roleName: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
  }, {
    sequelize,
    modelName: 'role',
  });
  return role;
};