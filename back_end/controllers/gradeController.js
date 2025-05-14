
const { user,subject, grade ,student,section,level,study_plan_elment } = require('../models'); 
const {Op, Sequelize} = require('sequelize');
const jwt = require("jsonwebtoken");
const SECRET_KEY = process.env.SECRET_KEY;

// get All Grades For specific =>  student_id  and  level_id and Term 
// student only can see his grades
exports.getGrades = async (req, res) => {
  try {
      const {studentID,levelID , Term} = req.query; 

      // Use a condition for levelID to prevent errors if it's not supplied
      const grades = await grade.findAll({
          where: {student_id:studentID , level_id:levelID , term:Term }, 
          include: [
              { model: subject, as: 'subject' },
            ],
      });

      if (!grades.length) {
          return res.status(404).json({ message: 'No grades found for this student' });
      }

      res.status(200).json({ message: 'These your grades', Grades: grades });
  } catch (error) {
      console.error('Error fetching grades:', error.message);
      res.status(500).json({ message: 'Internal server error', error: error.message });
  }
}; 

// doctors only can see all grades or use filters to specific (student,section,level,term,subject,yearofissue)
exports.getAllGrades = async (req, res) => {
  try {
    const {
      student_id,
      subject_id,
      term,
      section_id,
      level_id,
      year_of_issue
    } = req.query;

    const { count, rows: grades } = await grade.findAndCountAll({
      where: {
        ...(student_id && {
          student_id: student_id  
        }),
        ...(subject_id && {
          subject_id: subject_id  
        }),
        ...(term && {
          term: term  
        }),
        ...(section_id && {
          section_id: section_id  
        }),
        ...(level_id && {
          level_id: level_id  
        }),
        ...(year_of_issue && {
          year_of_issue: year_of_issue  
        }),
      },
      distinct: true,
    });

    if (!grades.length) {
      return res.status(404).json({ message: "No grades found for the specified criteria" });
    }


    res.status(200).json({
      message: "Grades retrieved successfully",
      data: grades,
      totalGrades: count,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error retrieving grades", error: error.message });
  }
}; 


exports.getGradesByCriteriaPanel = async (req, res) => {
  const ALLOWED_ORDER_FIELDS = ["student_id", "exam_grade","section_id","level_id", "work_grade", "term", "subject_id"];
  const ALLOWED_SORT_DIRECTIONS = ["ASC", "DESC"];

  try {
    const {
      student_id,
      subject_id,
      term,
      section_id,
      level_id,
      year_of_issue,
      page = 1,
      limit = 10,
      orderBy = "student_id",
      sort = "ASC",
      search,
    } = req.query;

    const whereClause = {};
    if (student_id) whereClause.student_id = student_id;
    if (subject_id) whereClause.subject_id = subject_id;
    // if (term) whereClause.term = term;
    if (section_id) whereClause.section_id = section_id;
    if (level_id) whereClause.level_id = level_id;
    // if (year_of_issue) whereClause.year_of_issue = year_of_issue;

    // const lang = req.headers["accept-language"] || "en"; 


    const pageNumber = parseInt(page, 10);
    let limitNumber = parseInt(limit, 10);

    const LOWER_LIMIT = 10;
    const UPPER_LIMIT = 250;
    if (isNaN(limitNumber)) limitNumber = LOWER_LIMIT;
    if (limitNumber < LOWER_LIMIT) limitNumber = LOWER_LIMIT;
    if (limitNumber > UPPER_LIMIT) limitNumber = UPPER_LIMIT;

    const offset = (pageNumber - 1) * limitNumber;

    const validOrderBy = ALLOWED_ORDER_FIELDS.includes(orderBy) ? orderBy : "student_id";
    const validSort = ALLOWED_SORT_DIRECTIONS.includes(sort.toUpperCase()) ? sort.toUpperCase() : "ASC";

    const searchCondition = search
      ? {
          [Op.or]: [
            { student_id: { [Op.like]: `%${search}%` } },
            { subject_id: { [Op.like]: `%${search}%` } },
            { term: { [Op.like]: `%${search}%` } },
            { status: { [Op.like]: `%${search}%` } },
          ],
        }
      : {};

    const { count, rows: grades } = await grade.findAndCountAll({
      where: {
        [Op.and]: [whereClause, searchCondition],
      },
      include: [
        { model: student, as: "student" },
        { model: subject, as: "subject" },
        { model: section, as: "section" },
        { model: level, as: "level" },
      ],
      limit: limitNumber,
      offset: offset,
      order: [[validOrderBy, validSort]],
    });


    // const { count1, rows: students } = await student.findAndCountAll({
    //   where: {
    //     ...(student_level_id && {
    //       student_level_id: student_level_id 
    //     }),
    //     ...(study_plan_id && {
    //       study_plan_id: study_plan_id 
    //     }),
    //     ...(enrollment_year && {
    //       enrollment_year:  enrollment_year 
    //     }),
    //     ...(studentSystem && {
    //       student_system:  { [lang]: studentSystem  }
    //     }),
    
    //     ...(search && {
    //       [Op.or]: [
    //         Sequelize.where(
    //           Sequelize.literal(`JSON_UNQUOTE(JSON_EXTRACT(${'user.user_name'}, '$.${lang}'))`),
    //           { [Op.like]: `%${search}%` }
    //         ),

    //       ]
    //     })
    //   },
    //   include: [
    //     {
    //       model: user,
    //       as: "user",
    //       required: true,
    //       attributes: ["user_name", "email", "date_of_birth", "collegeName", "user_section_id", "roleId"],
    //       include: [
    //         {
    //           model: section,
    //           as: "section",
    //           attributes: ["section_name"],
    //           required: true,
    //           where: {
    //             ...(sectionName && {
    //               section_name: { [lang]: sectionName }
    //             })
    //           }
    //         },
    //         {
    //           model: role,
    //           as: "role",
    //           attributes: ["roleName"],
    //           required: true,
    //           where: {
    //             ...(rolename && {
    //               roleName: rolename
    //             })
    //           }
    //         },
    //         {
    //           model: phone_number,
    //           as: "phone_numbers",
    //           attributes: ["phone_number"],
    //           // required: true,
    //         },
    //       ]
    //     }
    //   ],
    //   distinct: true, 
    //   limit: limitNumber,
    //   offset: offset,
    //   order: [[validOrderBy, validSort]],
    // });



    if (!grades.length) {
      return res.status(404).json({ message: "No grades found for the specified criteria" });
    }

    const gradeList = grades.map((grade) => ({
      grad_id: grade.grad_id,
      student_id: grade.student_id,
      subject_id: grade.subject_id,
      exam_grade: grade.exam_grade,
      work_grade: grade.work_grade,
      term: grade.term,
      section_id: grade.section_id,
      level_id: grade.level_id,
      year_of_issue: grade.year_of_issue,
      is_absent: grade.is_absent,
      status: grade.status,
    }));

    res.status(200).json({
      message: "Grades retrieved successfully",
      data: gradeList,
      pagination: {
        totalGrades: count,
        totalPages: Math.ceil(count / limitNumber),
        currentPage: pageNumber,
        perPage: limitNumber,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error retrieving grades", error: error.message });
  }
};


//   additional function i will deleted if it is unneccessary 
exports.getGradeById = async (req, res) => {
    try {
      const { id } = req.params;
  
      const gradeDetails = await grade.findOne({
        where: { grad_id: id },
        include: [
          { model: student, as: 'student' },
          { model: subject, as: 'subject' },
          { model: section, as: 'section'}
        ],
      });
  
      if (!gradeDetails) {
        return res.status(404).json({ message: 'Grade not found' });
      }
  
      res.status(200).json({ message: `This is  degree of ${id} ID `, grade: gradeDetails });
    } catch (error) {
      console.error('Error fetching grade:', error.message);
      res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

// To get All year_issue DISTINCT (without duplicate)
exports.getGradeYear = async (req, res) => {
  try {
    const uniqueYears = await grade.findAll({
      attributes: [
        [Sequelize.fn('DISTINCT', Sequelize.col('year_of_issue')), 'year']
      ],
      raw: true
    });

    if (uniqueYears.length === 0) {
      return res.status(404).json({ message: 'No unique years found in the Grade table' });
    }

    const years = uniqueYears.map(item => item.year);

    res.status(200).json({ message: 'Unique years retrieved successfully', data: years });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving unique years', error: error.message });
  }
};

//  To get section of current logged user 
exports.getSectionOfCurrentUser = (req, res) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) {
    return res.status(401).json({ message: "Access token is missing" });
  }

  jwt.verify(token, SECRET_KEY, async (err, decoded) => {
    if (err) {
      return res.status(403).json({ message: "Invalid token" });
    }

    try {
      const foundUser = await user.findOne({
        where: { user_id: decoded.user_id },
        include: [
          { model: student, as: "student" },
          { model: section, as: "section" },
        ],
      });

      if (!foundUser) {
        return res.status(404).json({ message: "User not found" });
      }
      res.json({
        message: "me",
        section: foundUser.user_section_id
      });
    } catch (error) {
      console.error("Error fetching user:", error.message);
      res.status(500).json({ message: "Internal server error", error: error.message });
    }
  });
};


// at frontEnd the  doctor can see all his subjects with details as cards 
// when he click any subject he will going to tables to see all students who study that subject with him and their degrees 
// and a doctor can write(create) degrees for all of them(his student who study this subject with him) or update their degrees >>> so  
//  when i deal with grades doctor  how i do (create , update and get ) functions ?????
// 
exports.createGrade = async (req, res) => {
  try {
    const studentExists = await student.findOne({ where: {student_id:req.body.student_id}});
    if (!studentExists) {
      return res.status(404).json({ message: 'Student not found' });
    }

    const subjectExists = await subject.findOne({where:{subject_id:req.body.subject_id}});
    if (!subjectExists) {
      return res.status(404).json({ message: 'Subject not found' });
    }

    const newGrade = await grade.create(req.body);
    res.status(201).json({
      message: 'Grade created successfully',
      grade: newGrade,
    });
  } catch (error) {
    console.error('Error creating grade:', error.message);
    res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};

exports.getDoctorGrades = async (req, res) => {
  try {
    const doctorId = req.user.user_id;
    const { sectionId, levelId, term } = req.query;

    const filters = {};
    if (sectionId) filters['$section.id$'] = sectionId;
    if (levelId) filters['$level.id$'] = levelId;
    if (term) filters['term'] = term;

    const grades = await grade.findAll({
      include: [
        {
          model: subject,
          include: [
            {
              model: study_plan_elment,
              where: { doctor_id: doctorId },
            },
          ],
        },
        {
          model: level,
        },
        {
          model: section,
        },
       
      ],
      where: filters,
    });

    res.status(200).json({ message: "Your student's grades", grades });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error fetching doctor grades', error });
  }
};

exports.updateGrade = async (req, res) => {
    try {
      const { id } = req.params;
      const {
        student_id,
        subject_id,
        exam_grade,
        work_grade,
        term,
        section,
        level,
        year_of_issue,
        is_absent,
        status,
      } = req.body;
  
      const gradeToUpdate = await grade.findOne({ where: { grad_id: id } });
  
      if (!gradeToUpdate) {
        return res.status(404).json({ message: 'Grade not found' });
      }
  
      // Check if student_id or subject_id are provided and validate them
      if (student_id) {
        const studentExists = await student.findByPk(student_id);
        if (!studentExists) {
          return res.status(404).json({ message: 'Student not found' });
        }
      }
  
      if (subject_id) {
        const subjectExists = await subject.findByPk(subject_id);
        if (!subjectExists) {
          return res.status(404).json({ message: 'Subject not found' });
        }
      }
  
      await gradeToUpdate.update({
        student_id,
        subject_id,
        exam_grade,
        work_grade,
        term,
        section,
        level,
        year_of_issue,
        is_absent,
        status,
      });
  
      res.status(200).json({
        message: 'Grade updated successfully',
        grade: gradeToUpdate,
      });
    } catch (error) {
      console.error('Error updating grade:', error.message);
      res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};

exports.deleteGrade = async (req, res) => {
    try {
      const { id } = req.params;
  
      const gradeToDelete = await grade.findOne({ where: { grad_id: id } });
  
      if (!gradeToDelete) {
        return res.status(404).json({ message: 'Grade not found' });
      }
  
      await gradeToDelete.destroy();
  
      res.status(200).json({ message: 'Grade deleted successfully' });
    } catch (error) {
      console.error('Error deleting grade:', error.message);
      res.status(500).json({ message: 'Internal server error', error: error.message });
    }
};