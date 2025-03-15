// controllers/userController.js
// const bcrypt = require('bcrypt');
const { user, doctor , student ,study_plan,level,section,phone_number,role} = require('../models'); 
const { Sequelize} = require('sequelize');
const { Op } = require("sequelize");


exports.getUserById = async (req, res) => {
    const { id } = req.params;
    try {
        const foundUser = await user.findOne({
            where:{user_id:id},
            include: [
                {model: student, as : 'student'},
                {model: doctor , as : 'doctor' },
                {model: student , as : 'student' }
            ],
        });
        if (!foundUser) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.status(200).json(foundUser);
    } catch (error) {
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

exports.getAllUsers = async (req, res) => {
    try {
        const users = await user.findAll();
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

exports.deleteUser = async (req, res) => {
    const { id } = req.params;
    try {
        const foundUser = await user.findByPk(id);
        if (!foundUser) {
            return res.status(404).json({ message: 'User not found' });
        }

        await foundUser.destroy();
        res.status(200).json({ message: 'User deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Internal server error', error: error.message });
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
            include: [{ model: doctor, as: 'doctor' }],
        });

        if (!foundUser || !foundUser.doctor) {
            return res.status(404).json({ message: "Doctor not found" });
        }

        res.status(200).json(foundUser);
    } catch (error) {
        console.error("Error fetching doctor:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.updateDoctor = async (req, res) => {
    const {  id: user_id  } = req.params;
    const { user_name, date_of_birth,collegeName, email,profile_picture, doctor: doctorData } = req.body;

    try {
        const foundUser = await user.findOne({
            where: { user_id },
            include: [{model: doctor,as: 'doctor',}],
            attributes: { exclude: ['resetToken', 'resetTokenExpiry', 'updatedAt'] }, 
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

        res.status(200).json({ message: "Doctor updated successfully", user: foundUser });
    } catch (error) {
        console.error("Error updating doctor:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.deleteDoctor = async (req, res) => {
    const { id: user_id } = req.params;

    try {
        const foundUser = await user.findOne({
            where: { user_id },
            include: [{ model: doctor, as: 'doctor' }],
        });

        if (!foundUser || !foundUser.doctor) {
            return res.status(404).json({ message: "Doctor not found" });
        }

        await foundUser.doctor.destroy();

        await foundUser.destroy();

        res.status(200).json({ message: "Doctor deleted successfully" });
    } catch (error) {
        console.error("Error deleting doctor:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.getAllDoctors = async (req, res) => {
    try {
        const doctors = await user.findAll({
            include: [{ 
                model: doctor, 
                as: 'doctor'
            }],
            where: { permission: 'teacher' }, 
        });

        const doctorsData = doctors.map(u => u.doctor?.getFullData() || {});
        res.status(200).json(doctorsData);
    } catch (error) {
        console.error("Error fetching doctors:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};


exports.getDoctorsByCriteriaPanle1 = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = [
    "doctor_id",
    "academic_degree",
    "administrative_position",
    "user_name",
    "email",
    "date_of_birth",
    "roleId",
    "collegeName",
    "phone_number",
    "section_name",
    "Role",
  ];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      doctor_id,
      academic_degree,
      administrative_position,
      user_name,
      date_of_birth,
      roleId,
      collegeName,
      phoneNumber,
      sectionName,
      Role,
      page = 1,
      limit = 10,
      orderBy = "doctor_id",
      sort = "ASC",
      search,
    } = req.query;

    const lang = req.headers["accept-language"] || "en"; // Default to 'en' if no language is specified

    const whereClause = {};    
    if (doctor_id) whereClause.doctor_id = doctor_id;    
    if (academic_degree) {
      whereClause.academic_degree = Sequelize.where(
        Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('academic_degree'), `$.${lang}`)),
        { [Op.like]: `%${academic_degree}%` }
      );
    }
    
    if (administrative_position) {
      whereClause.administrative_position = Sequelize.where(
        Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('administrative_position'), `$.en`)),
        { [Op.like]: `%${administrative_position}%` }
      );
    }
    
    if (user_name) {
      whereClause['$user.user_name$'] = Sequelize.where(
        Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('user.user_name'), `$.en`)),
        { [Op.like]: `%${user_name}%` }
      );
    }
    
    if (collegeName) {
      whereClause['$user.collegeName$'] = Sequelize.where(
        Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('user.collegeName'), `$.en`)),
        { [Op.like]: `%${collegeName}%` }
      );
    }
    
    if (Role) {
      whereClause['$user.role.roleName$'] = Sequelize.where(
        Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('user.role.roleName'), `$.en`)),
        { [Op.like]: `%${Role}%` }
      );
    }
    
    if (sectionName) {
      whereClause['$user.section.section_name$'] = Sequelize.where(
        Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('user.section.section_name'), `$.en`)),
        { [Op.like]: `%${sectionName}%` }
      );
    }
    
    // Fields in the `phone_number` table (nested association)
    if (phoneNumber) whereClause['$user.phone_numbers.phone_number$'] = phoneNumber;
    
    // Search condition
    const searchCondition = search
      ? {
          [Op.or]: [
            // Search by doctor_id (non-JSON field)
            { doctor_id: { [Op.like]: `%${search}%` } },
    
            // Search within JSON fields
            Sequelize.where(
              Sequelize.col('academic_degree'), // Access the JSON field
              { [Op.like]: `%${search}%` } // Search within the JSON object
            ),
            Sequelize.where(
              Sequelize.col('administrative_position'), // Access the JSON field
              { [Op.like]: `%${search}%` } // Search within the JSON object
            ),
            Sequelize.where(
              Sequelize.col('user.user_name'), // Access the JSON field
              { [Op.like]: `%${search}%` } // Search within the JSON object
            ),
            Sequelize.where(
              Sequelize.col('user.collegeName'), // Access the JSON field
              { [Op.like]: `%${search}%` } // Search within the JSON object
            ),
            Sequelize.where(
              Sequelize.col('user.role.roleName'), // Access the JSON field
              { [Op.like]: `%${search}%` } // Search within the JSON object
            ),
            Sequelize.where(
              Sequelize.col('user.section.section_name'), // Access the JSON field
              { [Op.like]: `%${search}%` } // Search within the JSON object
            ),
    
            // Search within phone_number (non-JSON field)
            { '$user.phone_numbers.phone_number$': { [Op.like]: `%${search}%` } },
          ],
        }
      : undefined;
    
    // Combine `whereClause` and `searchCondition`
    const where = {};
    
    if (Object.keys(whereClause).length > 0 || searchCondition) {
      where[Op.and] = [];
      if (Object.keys(whereClause).length > 0) where[Op.and].push(whereClause);
      if (searchCondition) where[Op.and].push(searchCondition);
    }

    console.log('\n \n \n where:', where ,'\n \n \n ')
    console.log('\n \n \n searchCondition:', searchCondition ,'\n \n \n ')

    // Pagination and sorting
    const pageNumber = parseInt(page, 10);
    let limitNumber = parseInt(limit, 10);

    const LOWER_LIMIT = 10;
    const UPPER_LIMIT = 250;
    if (isNaN(limitNumber)) limitNumber = LOWER_LIMIT;
    if (limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
    if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;

    const offset = (pageNumber - 1) * limitNumber;

    const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy) ? orderBy : "doctor_id";
    const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase()) ? sort.toUpperCase() : "ASC";

    // Step 1: Perform a separate count query
    const totalDoctors = await doctor.count({
      where: Object.keys(where).length > 0 ? where : undefined,
      include: [
        {
          model: user,
          as: 'user',
          include: [
            {
              model: section,
              as: 'section',
            },
            {
              model: role,
              as: 'role',
            },
            {
              model: phone_number,
              as: 'phone_numbers',
            },
          ],
        },
      ],
      distinct: true, // Ensure distinct counting
    });

    // Step 2: Fetch paginated data
    const doctors = await doctor.findAll({
      where: Object.keys(where).length > 0 ? where : undefined,
      include: [
        {
          model: user,
          as: 'user',
          attributes: ['user_name', 'email', 'date_of_birth', 'roleId', 'collegeName'],
          include: [
            {
              model: section,
              as: 'section',
              attributes: ['section_name'],
            },
            {
              model: role,
              as: 'role',
              attributes: ['roleName'],
            },
            {
              model: phone_number,
              as: 'phone_numbers',
              attributes: ['phone_number'],
            },
          ],
        },
      ],
      limit: limitNumber,
      offset: offset,
      order: [[validOrderBy, validSort]],
      logging: console.log,
    });

    if (!doctors.length) {
      return res.status(404).json({ message: "No doctors found for the specified criteria" });
    }

    // Format the response
    const doctorList = doctors.map((doctor) => ({
      doctor_id: doctor.doctor_id,
      academic_degree: doctor.academic_degree,
      administrative_position: doctor.administrative_position,
      user: {
        name: doctor.user.user_name,
        email: doctor.user.email,
        date_of_birth: doctor.user.date_of_birth,
        roleId: doctor.user.roleId,
        collegeName: doctor.user.collegeName,
        section: doctor.user.section?.section_name,
        Role: doctor.user.role?.roleName,
        phone_number: doctor.user.phone_numbers?.map(pn => pn.phone_number) || [],
      },
    }));

    // Return the response
    res.status(200).json({
      message: "Doctors retrieved successfully",
      data: doctorList,
      pagination: {
        totalDoctors: totalDoctors,
        totalPages: Math.ceil(totalDoctors / limitNumber),
        currentPage: pageNumber,
        perPage: limitNumber,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error retrieving doctors", error: error.message });
  }
};


exports.getDoctorsByCriteriaPanle = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = [
    "doctor_id",
    "academic_degree",
    "administrative_position",
    "user_name",
    "email",
    "date_of_birth",
    "roleId",
    "collegeName",
    "phone_number",
    "section_name",
    "Role",
  ];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      doctor_id,
      academic_degree,
      administrative_position,
      user_name,
      date_of_birth,
      roleId,
      collegeName,
      phoneNumber,
      sectionName,
      Role,
      page = 1,
      limit = 10,
      orderBy = "doctor_id",
      sort = "ASC",
      search,
    } = req.query;

    const lang = req.headers["accept-language"] || "en";
    console.log('\n \n \n req.query:', req.query, '\n \n \n ');

    const whereClause = {};

    // Top-level fields
    if (doctor_id) whereClause.doctor_id = doctor_id;

    // JSON fields in doctor
    if (academic_degree) {
      whereClause.academic_degree = Sequelize.where(
        Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('academic_degree'), `$.${lang}`)),
        { [Op.like]: `%${academic_degree}%` }
      );
    }

    if (administrative_position) {
      whereClause.administrative_position = Sequelize.where(
        Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('administrative_position'), `$.${lang}`)),
        { [Op.like]: `%${administrative_position}%` }
      );
    }

    // User fields (JSON)
    if (user_name) {
      whereClause['$user.user_name$'] = Sequelize.where(
        Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('user.user_name'), `$.${lang}`)),
        { [Op.like]: `%${user_name}%` }
      );
    }

    if (date_of_birth) whereClause['$user.date_of_birth$'] = date_of_birth;
    if (roleId) whereClause['$user.roleId$'] = roleId;

    if (collegeName) {
      whereClause['$user.collegeName$'] = Sequelize.where(
        Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('user.collegeName'), `$.${lang}`)),
        { [Op.like]: `%${collegeName}%` }
      );
    }

    // Role (nested association)
    if (Role) {
      whereClause['$user.role.roleName$'] = Sequelize.where(
        Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('user.role.roleName'), `$.${lang}`)),
        { [Op.like]: `%${Role}%` }
      );
    }

    // Section (nested association)
    if (sectionName) {
      whereClause['$user.section.section_name$'] = Sequelize.where(
        Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('user.section.section_name'), `$.${lang}`)),
        { [Op.like]: `%${sectionName}%` }
      );
    }

    if (phoneNumber) whereClause['$user.phone_numbers.phone_number$'] = phoneNumber;

    // Search condition
    const searchCondition = search
      ? {
          [Op.or]: [
            { doctor_id: { [Op.like]: `%${search}%` } },
            Sequelize.where(
              Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('academic_degree'), `$.${lang}`)),
              { [Op.like]: `%${search}%` }
            ),
            Sequelize.where(
              Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('administrative_position'), `$.${lang}`)),
              { [Op.like]: `%${search}%` }
            ),
            Sequelize.where(
              Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('user.user_name'), `$.${lang}`)),
              { [Op.like]: `%${search}%` }
            ),
            Sequelize.where(
              Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('user.collegeName'), `$.${lang}`)),
              { [Op.like]: `%${search}%` }
            ),
            Sequelize.where(
              Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('user.role.roleName'), `$.${lang}`)),
              { [Op.like]: `%${search}%` }
            ),
            Sequelize.where(
              Sequelize.fn('JSON_UNQUOTE', Sequelize.fn('JSON_EXTRACT', Sequelize.col('user.section.section_name'), `$.${lang}`)),
              { [Op.like]: `%${search}%` }
            ),
            { '$user.phone_numbers.phone_number$': { [Op.like]: `%${search}%` } },
          ],
        }
      : undefined;

    // Combine conditions
    const where = {};
    const conditions = [];

    if (Object.keys(whereClause).length > 0) conditions.push(whereClause);
    if (searchCondition) conditions.push(searchCondition);

    if (conditions.length > 0) {
      where[Op.and] = conditions; // Ensure `Op.and` is added to the `where` object
    }

    console.log('\n \n \n where:', JSON.stringify(where, null, 2), '\n \n \n ');
    console.log('\n \n \n searchCondition:', JSON.stringify(searchCondition, null, 2), '\n \n \n ');
    console.log('\n \n \n conditions:', JSON.stringify(conditions, null, 2), '\n \n \n ');
    console.log('\n \n \n whereClause:', JSON.stringify(whereClause, null, 2), '\n \n \n ');

    // 
    if (Object.keys(where).length === 0) {
      console.log('\n \n \n No filters applied \n \n \n ');;
    }

    // Pagination and sorting
    const pageNumber = parseInt(page, 10);
    let limitNumber = parseInt(limit, 10);

    const LOWER_LIMIT = 10;
    const UPPER_LIMIT = 250;
    if (isNaN(limitNumber)) limitNumber = LOWER_LIMIT;
    if (limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
    if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;

    const offset = (pageNumber - 1) * limitNumber;

    const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy) ? orderBy : "doctor_id";
    const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase()) ? sort.toUpperCase() : "ASC";

    // Count query with required includes
    const totalDoctors = await doctor.count({
      where: where,
      include: [
        {
          model: user,
          as: 'user',
          required: true, // Ensure INNER JOIN
          include: [
            { model: section, as: 'section', required: !!sectionName }, // Conditionally required
            { model: role, as: 'role', required: !!Role },
            { model: phone_number, as: 'phone_numbers', required: !!phoneNumber },
          ],
        },
      ],
      distinct: true,
    });

    // Find all doctors with required includes
    const doctors = await doctor.findAll({
      where: where,
      include: [
        {
          model: user,
          as: 'user',
          required: true,
          attributes: ['user_name', 'email', 'date_of_birth', 'roleId', 'collegeName'],
          include: [
            {
              model: section,
              as: 'section',
              attributes: ['section_name'],
              required: !!sectionName,
            },
            {
              model: role,
              as: 'role',
              attributes: ['roleName'],
              required: !!Role,
            },
            {
              model: phone_number,
              as: 'phone_numbers',
              attributes: ['phone_number'],
              required: !!phoneNumber,
            },
          ],
        },
      ],
      limit: limitNumber,
      offset: offset,
      order: [[validOrderBy, validSort]],
      logging: console.log,
    });

    if (!doctors.length) {
      return res.status(404).json({ message: "No doctors found for the specified criteria" });
    }

    // Format response
    const doctorList = doctors.map((doc) => ({
      doctor_id: doc.doctor_id,
      academic_degree: doc.academic_degree,
      administrative_position: doc.administrative_position,
      user: {
        name: doc.user.user_name,
        email: doc.user.email,
        date_of_birth: doc.user.date_of_birth,
        roleId: doc.user.roleId,
        collegeName: doc.user.collegeName,
        section: doc.user.section?.section_name,
        Role: doc.user.role?.roleName,
        phone_number: doc.user.phone_numbers?.map(pn => pn.phone_number) || [],
      },
    }));

    res.status(200).json({
      message: "Doctors retrieved successfully",
      data: doctorList,
      pagination: {
        totalDoctors: totalDoctors,
        totalPages: Math.ceil(totalDoctors / limitNumber),
        currentPage: pageNumber,
        perPage: limitNumber,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error retrieving doctors", error: error.message });
  }
};








// exports.getAllDoctors = async (req, res) => {
//     const { language } = req.query;

//     if (!language) {
//         return res.status(400).json({ message: "Language parameter is required" });
//     }

//     try {
//         const doctors = await doctor.findAll({
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

//         if (doctors.length === 0) {
//             return res.status(404).json({ message: 'No doctors found' });
//         }

//         const doctorsData = doctors.map(doctor => ({
//             user_name: doctor.user.user_name,
//             collegeName: doctor.user.collegeName,
//             date_of_birth: doctor.user.date_of_birth,
//             email: doctor.user.email,
//             academic_degree: doctor.academic_degree,
//             administrative_position: doctor.administrative_position
//         }));

//         res.status(200).json({
//             message: 'Doctors found',
//             data: doctorsData,
//         });
//     } catch (error) {
//         console.error('Error fetching doctors:', error.message);
//         res.status(500).json({ message: 'Internal server error', error: error.message });
//     }
// };


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exports.getStudentById = async (req, res) => {
    const { id: user_id } = req.params;

    try {
        const foundStudent = await student.findOne({
            where: { student_id:user_id },
            include: [{ model: user, as: 'user' }],
        });

        if (!foundStudent || !foundStudent.user) {
            return res.status(404).json({ message: "Student not found" });
        }

        res.status(200).json(foundStudent.getFullData());
    } catch (error) {
        console.error("Error fetching student:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.updateStudent = async (req, res) => {
    const { id: user_id } = req.params;
    const { user_name, date_of_birth,collegeName, email, profile_picture, student: studentData } = req.body;

    try {
        const foundUser = await user.findOne({
            where: { user_id },
            include: [{ model: student, as: 'student' }],
        });

        if (!foundUser || !foundUser.student) {
            return res.status(404).json({ message: "Student not found" });
        }

        const [sectionFound, levelFound, study_planFound] = await Promise.all([
            section.findOne({ where: { section_name: studentData.student_section_id } }),
            level.findOne({ where: { level_name: studentData.student_level_id } }),
            study_plan.findOne({ where: { study_plan_name: studentData.study_plan_id } })
        ]);

        if (!sectionFound) {
            return res.status(400).json({ message: `Section '${studentData.student_section_id}' not found` });
        }
        if (!levelFound) {
            return res.status(400).json({ message: `Level '${studentData.student_level_id}' not found` });
        }
        if (!study_planFound) {
            return res.status(400).json({ message: `Study plan '${studentData.study_plan_id}' not found` });
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
            collegeName:foundUser.collegeName,
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
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.deleteStudent = async (req, res) => {
    const { id: user_id } = req.params;

    try {
        const foundUser = await user.findOne({
            where: { user_id },
            include: [{ model: student, as: 'student' }],
        });

        if (!foundUser || !foundUser.student) {
            return res.status(404).json({ message: "Student not found" });
        }

        await foundUser.student.destroy();
        await foundUser.destroy();

        res.status(200).json({ message: "Student deleted successfully" });
    } catch (error) {
        console.error("Error deleting student:", error.message);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};

exports.getAllStudents = async (req, res) => {
    try {
        const users = await user.findAll({
            include: [{
                model: student,
                as: 'student',
            }],
            where: { permission: 'student' },
        });

        const students = users.map(u => u.student?.getFullData() || {});

        res.status(200).json(students);
    } catch (error) {
        console.error("Error fetching students:", error);
        res.status(500).json({ message: "Internal server error", error: error.message });
    }
};



exports.getStudentsByCriteriaPanle = async (req, res) => {
    const ALLOWED_ORDER_FIELDS = ["enrollment_year", "student_id", "student_level_id", "repeat_years_count",'user_name', 'email','date_of_birth','roleId','collegeName'];
    const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];
  
    try {
      const {
        student_id,
        study_plan_id,
        student_level_id,
        enrollment_year,
        repeat_years_count,
        user_name,
        date_of_birth,
        roleId,
        collegeName,
        phone_number,
        page = 1,
        limit = 10,
        orderBy = "enrollment_year",
        sort = "ASC",
        search,
      } = req.query;
  
      const whereClause = {};
      if (student_id) whereClause.student_id = student_id;
      if (study_plan_id) whereClause.study_plan_id = study_plan_id;
      if (student_level_id) whereClause.student_level_id = student_level_id;
      if (enrollment_year) whereClause.enrollment_year = enrollment_year;
      if (repeat_years_count) whereClause.repeat_years_count = repeat_years_count;
      if (user_name) whereClause.user_name =user_name ;
      if (date_of_birth) whereClause.date_of_birth =date_of_birth ;
      if (roleId) whereClause.roleId = roleId;
      if (collegeName) whereClause.collegeName =collegeName ;
    //   if (phone_number) whereClause.phone_number =phone_number ;
  
      const pageNumber = parseInt(page, 10);
      let limitNumber = parseInt(limit, 10);
  
      const LOWER_LIMIT = 10;
      const UPPER_LIMIT = 250;
      if (isNaN(limitNumber)) limitNumber = LOWER_LIMIT;
      if (limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
      if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;
  
      const offset = (pageNumber - 1) * limitNumber;
  
      const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy) ? orderBy : "enrollment_year";
      const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase()) ? sort.toUpperCase() : "ASC";
  
      const searchCondition = search
        ? {
            [Op.or]: [
              { student_id: { [Op.like]: `%${search}%` } },
              { student_system: { [Op.like]: `%${search}%` } },
              { user_name: { [Op.like]: `%${search}%` }},
              { date_of_birth: { [Op.like]: `%${search}%` }},
              { roleId: { [Op.like]: `%${search}%` }},
              { collegeName: { [Op.like]: `%${search}%` }},

            ],
          }
        : {};
  
      const { count, rows: students } = await student.findAndCountAll({
        where: {
          [Op.and]: [whereClause, searchCondition],
        },
        include: [
          { model: user,
            as: "user" ,
            attributes: [ 'user_name', 'email','date_of_birth','roleId','collegeName'], 
            // include:[
            //     {
            //     model:phone_number,
            //     as:'phone_numbers',
            //     attributes:['phone_number']
            //     }
            // ]

          },
        //   { model: study_plan, as: "study_plan" },
        //   { model: level, as: "level" },
        ],
        limit: limitNumber,
        offset: offset,
        order: [[validOrderBy, validSort]],
      });
  
      if (!students.length) {
        return res.status(404).json({ message: "No students found for the specified criteria" });
      }
  
      const studentList = students.map((student) => ({
        student_id: student.student_id,
        study_plan_id: student.study_plan_id,
        student_level_id: student.student_level_id,
        enrollment_year: student.enrollment_year,
        student_system: student.student_system,
        repeat_years_count: student.repeat_years_count,
        user:{
            name: student.user.user_name,
            email: student.user.email,
            date_of_birth:student.user.date_of_birth,
            roleId:student.user.roleId,
            collegeName:student.user.collegeName,
            //   phone_number:student.user.phone_numbers.map(pn => pn.phone_number)
        }
      }));
  
      res.status(200).json({
        message: "Students retrieved successfully",
        data: studentList,
        pagination: {
          totalStudents: count,
          totalPages: Math.ceil(count / limitNumber),
          currentPage: pageNumber,
          perPage: limitNumber,
        },
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Error retrieving students", error: error.message });
    }
};





