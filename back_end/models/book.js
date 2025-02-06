'use strict'; 
const { Model } = require('sequelize');
const bookHooks = require('../hooks/bookHooks');

module.exports = (sequelize, DataTypes) => {
  class book extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // Define associations here
      book.belongsTo(models.user, { foreignKey: 'added_by' });
      book.belongsTo(models.subject, { foreignKey: 'subject_id' });

      // Many-to-Many relationships
      book.belongsToMany(models.level, {
        through: 'bookSectionLevel',
        foreignKey: 'bookId',
      });
      book.belongsToMany(models.section, {
        through: 'bookSectionLevel',
        foreignKey: 'bookId',
      });
    }
  }
  
  // Define the model fields
  book.init(
    {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: DataTypes.INTEGER,
      },
      title: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      author: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      numberOfPages: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      edition: {
        type: DataTypes.STRING(50),
        allowNull: true,
      },
      category: {
        type: DataTypes.ENUM('Reference', 'Lecture', 'ExamForm'),
        allowNull: false,
      },
      file_size: {
        type: DataTypes.FLOAT,
        allowNull: true,
      },
      file_path: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
      display_image: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      added_by: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: 'users',
          key: 'user_id',
        },
        onDelete: 'NO ACTION',
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
    },
    {
      sequelize,
      modelName: 'book',
      indexes: [
      {
        unique: true,
        fields: ['title', 'numberOfPages', 'author', 'edition','category'],
        name: 'unique_constraint_in_book',
      },
        ],
    });
    book.addHook('afterCreate', bookHooks.afterCreate);
    return book;
};
