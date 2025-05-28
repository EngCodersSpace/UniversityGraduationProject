

"use strict";

const { faker, ar } = require("@faker-js/faker");
const { subject } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const subject_names = [
  // Level 1 (shared for all)
  { en: "Introduction to Engineering", ar: "مقدمة في الهندسة" },
  { en: "Mathematics I", ar: "الرياضيات ١" },
  { en: "Physics I", ar: "الفيزياء ١" },
  { en: "Technical Writing", ar: "الكتابة التقنية" },
  { en: "Computer Skills", ar: "مهارات الحاسوب" },
  // Architecture Level 2
  { en: "Architectural Drawing", ar: "الرسم المعماري" },
  { en: "Building Materials", ar: "مواد البناء" },
  { en: "Design Principles", ar: "مبادئ التصميم" },
  { en: "History of Architecture", ar: "تاريخ العمارة" },
  { en: "Model Making", ar: "صناعة النماذج" },
  // Architecture Level 3
  { en: "Urban Planning", ar: "التخطيط الحضري" },
  { en: "Architectural Theory", ar: "نظرية العمارة" },
  { en: "Building Construction", ar: "بناء المباني" },
  { en: "Architectural CAD", ar: "الرسم المعماري بالحاسوب" },
  { en: "Environmental Design", ar: "التصميم البيئي" },
  // Architecture Level 4
  { en: "Landscape Design", ar: "تصميم المناظر الطبيعية" },
  { en: "Interior Architecture", ar: "العمارة الداخلية" },
  { en: "Sustainable Design", ar: "التصميم المستدام" },
  { en: "Architectural Design Studio", ar: "استوديو التصميم المعماري" },
  { en: "Site Planning", ar: "تخطيط المواقع" },
  // Architecture Level 5
  { en: "Building Codes", ar: "أنظمة البناء" },
  { en: "Advanced Design Studio", ar: "استوديو التصميم المتقدم" },
  { en: "Project Management", ar: "إدارة المشاريع" },
  { en: "Architectural Acoustics", ar: "الضوضاء المعمارية" },
  { en: "Thesis Project", ar: "مشروع التخرج" },
  // Computer Level 2
  { en: "Programming I", ar: "برمجة ١" },
  { en: "Data Structures", ar: "هياكل البيانات" },
  { en: "Mathematics II", ar: "الرياضيات ٢" },
  { en: "Digital Logic", ar: "المنطق الرقمي" },
  { en: "Discrete Math", ar: "الرياضيات المتقطعة" },
  // Computer Level 3
  { en: "Algorithms", ar: "الخوارزميات" },
  { en: "Object-Oriented Programming", ar: "البرمجة الكائنية" },
  { en: "Operating Systems", ar: "أنظمة التشغيل" },
  { en: "Database Systems", ar: "أنظمة قواعد البيانات" },
  { en: "Software Engineering", ar: "هندسة البرمجيات" },

  // Computer Level 4
  { en: "Web Development", ar: "تطوير الويب" },
  { en: "Computer Networks", ar: "شبكات الحاسوب" },
  { en: "Cybersecurity", ar: "أمن المعلومات" },
  { en: "Mobile Development", ar: "تطوير التطبيقات" },
  { en: "Embedded Systems", ar: "الأنظمة المدمجة" },

  // Computer Level 5
  { en: "Machine Learning", ar: "تعلم الآلة" },
  { en: "Cloud Computing", ar: "الحوسبة السحابية" },
  { en: "Big Data", ar: "البيانات الضخمة" },
  { en: "AI Integration", ar: "دمج الذكاء الاصطناعي" },
  { en: "Capstone Project", ar: "مشروع التخرج" },

  // Communication Level 2
  { en: "Circuit Analysis", ar: "تحليل الدوائر" },
  { en: "Signals and Systems", ar: "الإشارات والأنظمة" },
  { en: "Analog Electronics", ar: "الإلكترونيات التناظرية" },
  { en: "Digital Logic", ar: "المنطق الرقمي" },
  { en: "Mathematics II", ar: "الرياضيات ٢" },

  // Communication Level 3
  { en: "Communication Systems", ar: "أنظمة الاتصالات" },
  { en: "Electromagnetics", ar: "الكهرومغناطيسية" },
  { en: "Microprocessors", ar: "المعالجات الدقيقة" },
  { en: "Digital Signal Processing", ar: "معالجة الإشارات الرقمية" },
  { en: "Control Systems", ar: "أنظمة التحكم" },

  // Communication Level 4
  { en: "Wireless Networks", ar: "الشبكات اللاسلكية" },
  { en: "Microwave Engineering", ar: "هندسة الموجات الدقيقة" },
  { en: "Optical Communication", ar: "الاتصالات البصرية" },
  { en: "Network Protocols", ar: "بروتوكولات الشبكات" },
  { en: "Embedded Systems", ar: "الأنظمة المدمجة" },

  // Communication Level 5
  { en: "Satellite Communication", ar: "الاتصالات عبر الأقمار الصناعية" },
  { en: "Signal Processing Applications", ar: "تطبيقات معالجة الإشارات" },
  { en: "Mobile Networks", ar: "شبكات المحمول" },
  { en: "Project in Communication", ar: "مشروع في الاتصالات" },
  { en: "Communication Ethics", ar: "أخلاقيات الاتصالات" },

  // Civil Level 2
  { en: "Engineering Drawing", ar: "الرسم الهندسي" },
  { en: "Surveying", ar: "المساحة" },
  { en: "Mechanics of Materials", ar: "ميكانيكا المواد" },
  { en: "Geology", ar: "الجيولوجيا" },
  { en: "Fluid Mechanics", ar: "ميكانيكا الموائع" },

  // Civil Level 3
  { en: "Soil Mechanics", ar: "ميكانيكا التربة" },
  { en: "Hydraulics", ar: "الهيدروليكا" },
  { en: "Structural Analysis", ar: "تحليل الهياكل" },
  { en: "Reinforced Concrete Design", ar: "تصميم الخرسانة المسلحة" },
  { en: "Transportation Engineering", ar: "هندسة النقل" },

  // Civil Level 4
  { en: "Steel Structures", ar: "الهياكل الفولاذية" },
  { en: "Construction Management", ar: "إدارة الإنشاءات" },
  { en: "Foundation Engineering", ar: "هندسة الأساسات" },
  { en: "Water Resources", ar: "موارد المياه" },
  { en: "Environmental Engineering", ar: "الهندسة البيئية" },

  // Civil Level 5
  { en: "Highway Engineering", ar: "هندسة الطرق" },
  { en: "Construction Materials", ar: "مواد البناء" },
  { en: "Project Planning", ar: "تخطيط المشاريع" },
  { en: "Advanced Structural Design", ar: "تصميم الهياكل المتقدمة" },
  { en: "Graduation Project", ar: "مشروع التخرج" },
];


    const subjects = [];
    for (let i = 0; i < subject_names.length; i++) {
      subjects.push({
        subject_id: `subject_${i}`,
        subject_name: subject_names[i], 
        number_of_units: faker.number.int({min:2,max:3}),
        subject_description:{ 
          en:`This is the description for ${subject_names[i].en}.`,
          ar:`هذا الوصف ل ${subject_names[i].ar}.`,
      },
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
    
    await subject.bulkCreate(subjects);
  },

  down: async (queryInterface, Sequelize) => {
    await subject.destroy({ where: {}, truncate: false });
  },
};
