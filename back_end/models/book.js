'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class book extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here

      //(1)Relationship One-to-Many between "book table" and  "user table"
      book.belongsTo(models.user, {
        foreignKey: 'added_by',
      });

      //(2)Relationship One-to-Many between "book table" and  "subject table"
      book.belongsTo(models.subject, {
        foreignKey: 'subject_id',
      });
      //(3)Relationship Many-to-Many between "book table" and  "level table through bookSectionLevel"
      book.belongsToMany(models.level, {
        through: 'bookSectionLevel',
        foreignKey: 'bookId',
      });
      //(4)Relationship Many-to-Many between "book table" and  "section table through bookSectionLevel"
      book.belongsToMany(models.section, {
        through: 'bookSectionLevel',
        foreignKey: 'bookId',
      });


    }
  }
  book.init({

    id: {
      allowNull: false,
      autoIncrement: true,
      primaryKey: true,
      type: DataTypes.INTEGER
    },
    title: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    author: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    isbn: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },
    edition: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },
    category: {
      type: DataTypes.ENUM('Book', 'Reference', 'Lecture', 'Summary', 'Exam', 'Other'),
      allowNull: false,
    },
    file_size: {
      type: DataTypes.FLOAT,
      allowNull: true,
    },
    file_path: {
      type: DataTypes.TEXT,
      allowNull: false,
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


  }, {
    sequelize,
    modelName: 'book',
  });
  return book;
};