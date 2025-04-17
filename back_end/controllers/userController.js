// controllers/userController.js
// const bcrypt = require('bcrypt');
const { user, doctor , student ,study_plan,level,section,phone_number,role} = require('../models'); 
const { Sequelize,Op} = require('sequelize');
const {filterJsonColumn} = require('../middleware/filterJsonCol')


exports.getUserById = async (req, res) => {
  const { id } = req.params;
  try {
    const foundUser = await user.findOne({
      where: { user_id: id },
      include: [
        { model: student, as: "student" },
        { model: doctor, as: "doctor" },
        { model: student, as: "student" },
      ],
    });
    if (!foundUser) {
      return res.status(404).json({ message: "User not found" });
    }
    res.status(200).json(foundUser);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

exports.getAllUsers = async (req, res) => {
  try {
    const users = await user.findAll();
    res.status(200).json(users);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

exports.deleteUser = async (req, res) => {
  const { id } = req.params;
  try {
    const foundUser = await user.findByPk(id);
    if (!foundUser) {
      return res.status(404).json({ message: "User not found" });
    }

    await foundUser.destroy();
    res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// exports.getDoctorById = async (req, res) => {
//     const { id } = req.params;
//     const { language } = req.query;

//     if (!language) {
//         return res.status(400).json({ message: "Language parameter is required" });
//     }

//     try {
//         const Doctor = await doctor.findOne({
//             where: { doctor_id: id },
//             attributes: [
//                     [Sequelize.json(`academic_degree.${language}`), 'academic_degree'],
//                     [Sequelize.json(`administrative_position.${language}`), 'administrative_position']
//                 ],
//             include: [
//                 {
//                     model: user,
//                     as: 'user',
//                     attributes: [
//                         'user_id',
//                         [Sequelize.json(`user_name.${language}`), 'user_name'],
//                         [Sequelize.json(`collegeName.${language}`), 'collegeName'],
//                         'date_of_birth',
//                         'email'
//                     ],
//                 },
//             ],
//         });

//         if (!Doctor) {
//             return res.status(404).json({ message: 'Doctor not found' });
//         }

//         const doctorData = {
//             user_id: Doctor.user.user_id,
//             user_name: Doctor.user.user_name,
//             collegeName: Doctor.user.collegeName,
//             date_of_birth: Doctor.user.date_of_birth,
//             email: Doctor.user.email,
//             doctor: {
//                 academic_degree: Doctor.academic_degree,
//                 administrative_position: Doctor.administrative_position
//             }
//         };

//         res.status(200).json({
//             message: 'Doctor found',
//             data: doctorData,
//         });
//     } catch (error) {
//         console.error('Error fetching doctor by ID:', error.message);
//         res.status(500).json({ message: 'Internal server error', error: error.message });
//     }
// };

exports.getDoctorById = async (req, res) => {
  const { id: user_id } = req.params;

  try {
    const foundUser = await user.findOne({
      where: { user_id },
      include: [{ model: doctor, as: "doctor" }],
    });

    if (!foundUser || !foundUser.doctor) {
      return res.status(404).json({ message: "Doctor not found" });
    }

    res.status(200).json(foundUser);
  } catch (error) {
    console.error("Error fetching doctor:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

exports.updateDoctor = async (req, res) => {
  const { id: user_id } = req.params;
  const {
    user_name,
    date_of_birth,
    collegeName,
    email,
    profile_picture,
    doctor: doctorData,
  } = req.body;

  try {
    const foundUser = await user.findOne({
      where: { user_id },
      include: [{ model: doctor, as: "doctor" }],
      attributes: { exclude: ["resetToken", "resetTokenExpiry", "updatedAt"] },
    });

    if (!foundUser || !foundUser.doctor) {
      return res.status(404).json({ message: "Doctor not found" });
    }

    await foundUser.update({
      user_name,
      date_of_birth,
      collegeName,
      email,
      profile_picture,
    });

    if (doctorData) {
      await foundUser.doctor.update({
        department: doctorData.department,
        academic_degree: doctorData.academic_degree,
        administrative_position: doctorData.administrative_position,
      });
    }

    res
      .status(200)
      .json({ message: "Doctor updated successfully", user: foundUser });
  } catch (error) {
    console.error("Error updating doctor:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

exports.deleteDoctor = async (req, res) => {
  const { id: user_id } = req.params;

  try {
    const foundUser = await user.findOne({
      where: { user_id },
      include: [{ model: doctor, as: "doctor" }],
    });

    if (!foundUser || !foundUser.doctor) {
      return res.status(404).json({ message: "Doctor not found" });
    }

    await foundUser.doctor.destroy();

    await foundUser.destroy();

    res.status(200).json({ message: "Doctor deleted successfully" });
  } catch (error) {
    console.error("Error deleting doctor:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

exports.getAllDoctors = async (req, res) => {
  try {
    const doctors = await doctor.findAll({
      include: [
        {
          model: user,
          as: "user",
        },
      ],
    });

    // const doctorsData = doctors.map((u) => u.doctor?.getFullData() || {});
    res.status(200).json(doctors);

  } catch (error) {
    console.error("Error fetching doctors:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

 

exports.getDoctorsByCriteriaPanle = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = [
    "doctor_id",
    "academic_degree",
    "administrative_position",
    "user_name",
    "collegeName",
    "phone_number",
    "section_name",
  ];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      academic_degree,
      administrative_position,
      user_name,
      rolename,
      sectionName,
      page = 1,
      limit = 10,
      orderBy = "doctor_id",
      sort = "ASC",
      search,
    } = req.query;

    const lang = req.headers["accept-language"] || "en"; 

    // Pagination and sorting
    const pageNumber = parseInt(page, 10);
    let limitNumber = parseInt(limit, 10);

    const LOWER_LIMIT = 10;
    const UPPER_LIMIT = 250;
    if (isNaN(limitNumber)) limitNumber = LOWER_LIMIT;
    if (limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
    if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;

    const offset = (pageNumber - 1) * limitNumber;

    const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy)
      ? orderBy
      : "doctor_id";
    const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase())
      ? sort.toUpperCase()
      : "ASC";


    const { count, rows: doctors }= await doctor.findAndCountAll({
      where: {
        ...(academic_degree && {
          academic_degree: { [lang]: academic_degree }
        }),
        ...(administrative_position && {
          administrative_position: { [lang]: administrative_position }
        }),
    
        ...(search && {
          [Op.or]: [
            // Doctor's JSON fields
            // Sequelize.where(
            //   Sequelize.literal(`JSON_UNQUOTE(JSON_EXTRACT(${'academic_degree'}, '$.${lang}'))`),
            //   { [Op.like]: `%${search}%` }
            // ),

            // Sequelize.where(
            //   Sequelize.literal(`JSON_UNQUOTE(JSON_EXTRACT(${'administrative_position'}, '$.${lang}'))`),
            //   { [Op.like]: `%${search}%` }
            // ),

            Sequelize.where(
              Sequelize.literal(`JSON_UNQUOTE(JSON_EXTRACT(${'user.user_name'}, '$.${lang}'))`),
              { [Op.like]: `%${search}%` }
            ),

          ]
        })
      },
      include: [
        {
          model: user,
          as: "user",
          required: true,
          include: [
            {
              model: section,
              as: "section",
              required: true,
              where: {
                ...(sectionName && {
                  section_name: { [lang]: sectionName }
                })
              }
            },
            {
              model: role,
              as: "role",
              required: true,
              where: {
                ...(rolename && {
                  roleName: rolename
                })
              }
            },
            {
              model: phone_number,
              as: "phone_numbers",
              attributes: ["phone_number"],
              required: true,
            }
          ]
        }
      ],
      flatten: true,
      distinct: true, 
      limit: limitNumber,
      offset: offset,
      order: [[validOrderBy, validSort]],
      logging: console.log,
    });

    if (!doctors.length) {
      return res
        .status(404)
        .json({ message: "No doctors found for the specified criteria ",s:search,n:user_name });
    }
    // Return the response
    res.status(200).json({
      message: "Doctors retrieved successfully",
      data: doctors.map((doc) => doc.getFullData()),
      pagination: {
        totalDoctors: count,
        totalPages: Math.ceil(count / limitNumber),
        currentPage: pageNumber,
        perPage: limitNumber,
      },
    });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Error retrieving doctors", error: error.message });
  }
};



//////////////////////////////////////////////


exports.getStudentById = async (req, res) => {
  const { id: user_id } = req.params;

  try {
    const foundStudent = await student.findOne({
      where: { student_id: user_id },
      include: [{ model: user, as: "user" }],
    });

    if (!foundStudent || !foundStudent.user) {
      return res.status(404).json({ message: "Student not found" });
    }

    res.status(200).json(foundStudent.getFullData());
  } catch (error) {
    console.error("Error fetching student:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

exports.updateStudent = async (req, res) => {
  const { id: user_id } = req.params;
  const {
    user_name,
    date_of_birth,
    collegeName,
    email,
    profile_picture,
    student: studentData,
  } = req.body;

  try {
    const foundUser = await user.findOne({
      where: { user_id },
      include: [{ model: student, as: "student" }],
    });

    if (!foundUser || !foundUser.student) {
      return res.status(404).json({ message: "Student not found" });
    }

    const [sectionFound, levelFound, study_planFound] = await Promise.all([
      section.findOne({
        where: { section_name: studentData.student_section_id },
      }),
      level.findOne({ where: { level_name: studentData.student_level_id } }),
      study_plan.findOne({
        where: { study_plan_name: studentData.study_plan_id },
      }),
    ]);

    if (!sectionFound) {
      return res
        .status(400)
        .json({
          message: `Section '${studentData.student_section_id}' not found`,
        });
    }
    if (!levelFound) {
      return res
        .status(400)
        .json({ message: `Level '${studentData.student_level_id}' not found` });
    }
    if (!study_planFound) {
      return res
        .status(400)
        .json({
          message: `Study plan '${studentData.study_plan_id}' not found`,
        });
    }

    await foundUser.update({
      user_name,
      date_of_birth,
      collegeName,
      email,
      profile_picture,
    });

    await foundUser.student.update({
      student_section_id: sectionFound.id,
      enrollment_year: studentData.enrollment_year,
      student_level_id: levelFound.id,
      student_system: studentData.student_system,
      study_plan_id: study_planFound.study_plan_id,
    });

    const responseUser = {
      user_id: foundUser.user_id,
      user_name: foundUser.user_name,
      date_of_birth: foundUser.date_of_birth,
      collegeName: foundUser.collegeName,
      email: foundUser.email,
      profile_picture: foundUser.profile_picture,
      student_section_id: sectionFound.section_name,
      enrollment_year: foundUser.student.enrollment_year,
      student_level_id: levelFound.level_name,
      student_system: foundUser.student.student_system,
      study_plan_id: study_planFound.study_plan_name,
    };

    res.status(200).json({
      message: "Student updated successfully",
      user: responseUser,
    });
  } catch (error) {
    console.error("Error updating student:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

exports.deleteStudent = async (req, res) => {
  const { id: user_id } = req.params;

  try {
    const foundUser = await user.findOne({
      where: { user_id },
      include: [{ model: student, as: "student" }],
    });

    if (!foundUser || !foundUser.student) {
      return res.status(404).json({ message: "Student not found" });
    }

    await foundUser.student.destroy();
    await foundUser.destroy();

    res.status(200).json({ message: "Student deleted successfully" });
  } catch (error) {
    console.error("Error deleting student:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

exports.getAllStudents = async (req, res) => {
  try {
    const students = await student.findAll({
      include: [
        {
          model: user,
          as: "user",
        },
      ],
      
    });

    // const students = users.map((u) => u.student?.getFullData() || {});

    res.status(200).json(students);
  } catch (error) {
    console.error("Error fetching students:", error);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

exports.getStudentsByCriteriaPanle = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = [
    "enrollment_year",
    "student_id",
    "student_level_id",
    "repeat_years_count",
    "user_name",
    "section_name",
  ];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      study_plan_id,
      student_level_id,
      enrollment_year,
      studentSystem,
      sectionName,
      rolename,
      page = 1,
      limit = 10,
      orderBy = "enrollment_year",
      sort = "ASC",
      search,
    } = req.query;

    const lang = req.headers["accept-language"] || "en"; 


    const pageNumber = parseInt(page, 10);
    let limitNumber = parseInt(limit, 10);

    const LOWER_LIMIT = 10;
    const UPPER_LIMIT = 250;
    if (isNaN(limitNumber)) limitNumber = LOWER_LIMIT;
    if (limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
    if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;

    const offset = (pageNumber - 1) * limitNumber;

    const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy)
      ? orderBy
      : "student_id";
    const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase())
      ? sort.toUpperCase()
      : "ASC";


    const { count, rows: students } = await student.findAndCountAll({
      where: {
        ...(student_level_id && {
          student_level_id: student_level_id 
        }),
        ...(study_plan_id && {
          study_plan_id: study_plan_id 
        }),
        ...(enrollment_year && {
          enrollment_year:  enrollment_year 
        }),
        ...(studentSystem && {
          student_system:  { [lang]: studentSystem  }
        }),
    
        ...(search && {
          [Op.or]: [
            Sequelize.where(
              Sequelize.literal(`JSON_UNQUOTE(JSON_EXTRACT(${'user.user_name'}, '$.${lang}'))`),
              { [Op.like]: `%${search}%` }
            ),

          ]
        })
      },
      include: [
        {
          model: user,
          as: "user",
          required: true,
          attributes: ["user_name", "email", "date_of_birth", "collegeName", "user_section_id", "roleId"],
          include: [
            {
              model: section,
              as: "section",
              attributes: ["section_name"],
              required: true,
              where: {
                ...(sectionName && {
                  section_name: { [lang]: sectionName }
                })
              }
            },
            {
              model: role,
              as: "role",
              attributes: ["roleName"],
              required: true,
              where: {
                ...(rolename && {
                  roleName: rolename
                })
              }
            },
            {
              model: phone_number,
              as: "phone_numbers",
              attributes: ["phone_number"],
              // required: true,
            },
          ]
        }
      ],
      distinct: true, 
      limit: limitNumber,
      offset: offset,
      order: [[validOrderBy, validSort]],
    });

    if (!students.length) {
      return res
        .status(404)
        .json({ message: "No students found for the specified criteria" });
    }

    res.status(200).json({
      message: "Students retrieved successfully",
      data: students.map((stu) => stu.getFullData()),
      pagination: {
        totalStudents: count,
        totalPages: Math.ceil(count / limitNumber),
        currentPage: pageNumber,
        perPage: limitNumber,
      },
    });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Error retrieving students", error: error.message });
  }
};
