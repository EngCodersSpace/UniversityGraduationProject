'use strict';

const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class income extends Model {
    /**
     * Define associations here
     */
    static associate(models) {
      // Income belongs to Customer (optional)
      income.belongsTo(models.customer, {
        foreignKey: 'customerId'
      });
    }
  }

  income.init(
    {
      id: {
        type: DataTypes.UUID,
        allowNull: false,
        primaryKey: true,
        defaultValue: DataTypes.UUIDV4
      },

      date: {
        type: DataTypes.DATEONLY,
        allowNull: false
      },

      amount: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false
      },

      source: {
        type: DataTypes.STRING,
        allowNull: true
      },

      customerId: {
        type: DataTypes.UUID,
        allowNull: true,
        references: {
          model: 'customers',
          key: 'id'
        },
        onUpdate: 'CASCADE',
        onDelete: 'SET NULL'
      },

      paymentMethod: {
        type: DataTypes.STRING,
        allowNull: true
      },

      attachment: {
        type: DataTypes.STRING,
        allowNull: true
      },

      notes: {
        type: DataTypes.TEXT,
        allowNull: true
      }
    },
    {
      sequelize,
      modelName: 'income',
      tableName: 'incomes',
      timestamps: true
    }
  );

  return income;
};
