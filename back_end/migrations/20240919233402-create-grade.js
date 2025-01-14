'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('grades', {
      grad_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
      },
      student_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'students',
          key: 'student_id',
        },
        onDelete: 'CASCADE',//if a student is delete the grade associated with him will be deleted
        onUpdate: 'CASCADE',//if a student is update the grade associated with him will be updated
      },
      subject_id: {
        type: Sequelize.STRING(10),
        allowNull: false,
        references: {
          model: 'subjects',
          key: 'subject_id',
        },
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
      },
      exam_grade: {
        type: Sequelize.TINYINT,
        allowNull: true,
      },
      work_grade: {
        type: Sequelize.TINYINT,
        allowNull: true,
      },
      term: {
        type: Sequelize.ENUM('Term 1', 'Term 2'),
        allowNull: false,
      },
      section_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'sections',
          key: 'id',
        },
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
      },
      level_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'levels',
          key: 'id',
        },
        onDelete: 'NO ACTION',
        onUpdate: 'CASCADE',
      },
      //Year the grade was issued
      year_of_issue: {
        type: Sequelize.DATEONLY,
        allowNull: false,
      },
      //Determine if the student is absent or not .[if "true '1' " =>(he is absent) , if "false '0' " =>(he is not absent)]
      is_absent: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: false,
      },
      //Determine if the student has tested the subject before or not .[if "Repeater" =>(he is tested before) , if "Freshman" =>(he has never tested it before)]
      status: {
        type: Sequelize.ENUM('Freshman', 'Repeater'),
        allowNull: false,
        defaultValue: 'Freshman',
      },
      // //How many times did he retest the subject 
      // //Write a function to increase the value by +1  in every each time he retake the subject test
      // retake_count: {
      //   type: DataTypes.INTEGER,
      //   allowNull: false,
      //   defaultValue: 0,
      // },




      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('grades');
  }
};