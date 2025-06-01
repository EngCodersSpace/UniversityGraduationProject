"use strict";

const { faker, ar } = require("@faker-js/faker");
const { subject } = require("../models");

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const subject_names = [
      // Level 1 (shared for all) - 10 subjects
      { en: "Introduction to Engineering", ar: "مقدمة في الهندسة" },
      { en: "Mathematics I", ar: "الرياضيات ١" },
      { en: "Physics I", ar: "الفيزياء ١" },
      { en: "Technical Writing", ar: "الكتابة التقنية" },
      { en: "Computer Skills", ar: "مهارات الحاسوب" },
      { en: "Engineering Ethics", ar: "أخلاقيات الهندسة" },
      { en: "Calculus I", ar: "التفاضل والتكامل ١" },
      { en: "Chemistry Fundamentals", ar: "أساسيات الكيمياء" },
      { en: "Engineering Drawing", ar: "الرسم الهندسي" },
      { en: "Probability and Statistics", ar: "الإحصاء والاحتمالات" },
      { en: "Calculus II", ar: "التفاضل والتكامل ٢" },
      { en: "Physics II", ar: "الفيزياء ٢" },
      { en: "Engineering Economics", ar: "الاقتصاد الهندسي" },
      { en: "Engineering Ethics", ar: "أخلاقيات الهندسة" },
      { en: "Linear Algebra", ar: "الجبر الخطي" },
      { en: "Differential Equations", ar: "المعادلات التفاضلية" },
      { en: "Engineering Mechanics", ar: "الميكانيكا الهندسية" },
      { en: "Introduction to Programming", ar: "مقدمة في البرمجة" },
      { en: "Engineering Materials", ar: "المواد الهندسية" },
      { en: "Project Management Fundamentals", ar: "أساسيات إدارة المشاريع" },

      // Architecture Level 2 - 12 subjects
      { en: "Architectural Drawing", ar: "الرسم المعماري" },
      { en: "Building Materials", ar: "مواد البناء" },
      { en: "Design Principles", ar: "مبادئ التصميم" },
      { en: "History of Architecture", ar: "تاريخ العمارة" },
      { en: "Model Making", ar: "صناعة النماذج" },
      { en: "Architectural Geometry", ar: "الهندسة المعمارية" },
      { en: "Environmental Science", ar: "العلوم البيئية" },
      { en: "Digital Presentation", ar: "العرض الرقمي" },
      { en: "Building Systems", ar: "أنظمة البناء" },
      { en: "Structural Concepts", ar: "المفاهيم الإنشائية" },
      { en: "Color Theory", ar: "نظرية الألوان" },
      { en: "Site Analysis", ar: "تحليل الموقع" },

      // Architecture Level 3 - 12 subjects
      { en: "Urban Planning", ar: "التخطيط الحضري" },
      { en: "Architectural Theory", ar: "نظرية العمارة" },
      { en: "Building Construction", ar: "بناء المباني" },
      { en: "Architectural CAD", ar: "الرسم المعماري بالحاسوب" },
      { en: "Environmental Design", ar: "التصميم البيئي" },
      { en: "Housing Design", ar: "تصميم المساكن" },
      { en: "Architectural Acoustics", ar: "الضوضاء المعمارية" },
      { en: "Historical Preservation", ar: "الحفاظ التاريخي" },
      { en: "Lighting Design", ar: "تصميم الإضاءة" },
      { en: "Passive Design Strategies", ar: "استراتيجيات التصميم السلبي" },
      { en: "Building Information Modeling", ar: "نمذجة معلومات البناء" },
      { en: "Cultural Aspects of Design", ar: "الجوانب الثقافية في التصميم" },

      // Architecture Level 4 - 12 subjects
      { en: "Landscape Design", ar: "تصميم المناظر الطبيعية" },
      { en: "Interior Architecture", ar: "العمارة الداخلية" },
      { en: "Sustainable Design", ar: "التصميم المستدام" },
      { en: "Architectural Design Studio", ar: "استوديو التصميم المعماري" },
      { en: "Site Planning", ar: "تخطيط المواقع" },
      { en: "Urban Design Studio", ar: "استوديو التصميم الحضري" },
      { en: "Advanced Structures", ar: "الإنشاءات المتقدمة" },
      { en: "Facade Engineering", ar: "هندسة الواجهات" },
      { en: "Parametric Design", ar: "التصميم البارامتري" },
      { en: "Architectural Criticism", ar: "النقد المعماري" },
      { en: "Housing Complex Design", ar: "تصميم المجمعات السكنية" },
      { en: "Disaster-Resistant Design", ar: "التصميم المقاوم للكوارث" },

      // Architecture Level 5 - 12 subjects
      { en: "Building Codes", ar: "أنظمة البناء" },
      { en: "Advanced Design Studio", ar: "استوديو التصميم المتقدم" },
      { en: "Project Management", ar: "إدارة المشاريع" },
      { en: "Professional Practice", ar: "الممارسة المهنية" },
      { en: "Thesis Project", ar: "مشروع التخرج" },
      { en: "Urban Regeneration", ar: "التجديد الحضري" },
      { en: "Digital Fabrication", ar: "التصنيع الرقمي" },
      { en: "Real Estate Development", ar: "تطوير العقارات" },
      { en: "Advanced Environmental Systems", ar: "الأنظمة البيئية المتقدمة" },
      { en: "Architectural Entrepreneurship", ar: "ريادة الأعمال المعمارية" },
      { en: "Global Architecture", ar: "العمارة العالمية" },
      { en: "Portfolio Development", ar: "تطوير المحفظة المعمارية" },

      // Computer Level 2 - 12 subjects
      { en: "Programming I", ar: "برمجة ١" },
      { en: "Data Structures", ar: "هياكل البيانات" },
      { en: "Mathematics II", ar: "الرياضيات ٢" },
      { en: "Digital Logic", ar: "المنطق الرقمي" },
      { en: "Discrete Math", ar: "الرياضيات المتقطعة" },
      { en: "Computer Organization", ar: "تنظيم الحاسوب" },
      { en: "Object-Oriented Programming", ar: "البرمجة الكائنية" },
      { en: "Web Fundamentals", ar: "أساسيات الويب" },
      { en: "Linux Systems", ar: "أنظمة لينكس" },
      { en: "Computational Thinking", ar: "التفكير الحسابي" },
      { en: "Data Management", ar: "إدارة البيانات" },
      { en: "Human-Computer Interaction", ar: "التفاعل بين الإنسان والحاسوب" },

      // Computer Level 3 - 12 subjects
      { en: "Algorithms", ar: "الخوارزميات" },
      { en: "Object-Oriented Design", ar: "التصميم الكائني" },
      { en: "Operating Systems", ar: "أنظمة التشغيل" },
      { en: "Database Systems", ar: "أنظمة قواعد البيانات" },
      { en: "Software Engineering", ar: "هندسة البرمجيات" },
      { en: "Computer Networks", ar: "شبكات الحاسوب" },
      { en: "System Analysis", ar: "تحليل النظم" },
      { en: "Artificial Intelligence", ar: "الذكاء الاصطناعي" },
      { en: "Compiler Design", ar: "تصميم المترجمات" },
      { en: "Distributed Systems", ar: "الأنظمة الموزعة" },
      { en: "Computer Graphics", ar: "الرسومات الحاسوبية" },
      { en: "Information Security", ar: "أمن المعلومات" },

      // Computer Level 4 - 12 subjects
      { en: "Web Development", ar: "تطوير الويب" },
      { en: "Computer Networks", ar: "شبكات الحاسوب" },
      { en: "Cybersecurity", ar: "أمن المعلومات" },
      { en: "Mobile Development", ar: "تطوير التطبيقات" },
      { en: "Embedded Systems", ar: "الأنظمة المدمجة" },
      { en: "Cloud Computing", ar: "الحوسبة السحابية" },
      { en: "Data Mining", ar: "تنقيب البيانات" },
      { en: "Computer Vision", ar: "الرؤية الحاسوبية" },
      { en: "Natural Language Processing", ar: "معالجة اللغة الطبيعية" },
      { en: "Parallel Computing", ar: "الحوسبة المتوازية" },
      { en: "IoT Systems", ar: "أنظمة إنترنت الأشياء" },
      { en: "Blockchain Technology", ar: "تكنولوجيا البلوكشين" },

      // Computer Level 5 - 12 subjects
      { en: "Machine Learning", ar: "تعلم الآلة" },
      { en: "Cloud Computing", ar: "الحوسبة السحابية" },
      { en: "Big Data", ar: "البيانات الضخمة" },
      { en: "AI Integration", ar: "دمج الذكاء الاصطناعي" },
      { en: "Capstone Project", ar: "مشروع التخرج" },
      { en: "Quantum Computing", ar: "الحوسبة الكمية" },
      { en: "Advanced Algorithms", ar: "الخوارزميات المتقدمة" },
      { en: "Robotics", ar: "الروبوتات" },
      { en: "DevOps Engineering", ar: "هندسة ديفأوبس" },
      { en: "Software Architecture", ar: "هندسة البرمجيات" },
      { en: "Ethical Hacking", ar: "الاختراق الأخلاقي" },
      { en: "Data Science", ar: "علم البيانات" },

      // Communication Level 2 - 12 subjects
      { en: "Circuit Analysis", ar: "تحليل الدوائر" },
      { en: "Signals and Systems", ar: "الإشارات والأنظمة" },
      { en: "Analog Electronics", ar: "الإلكترونيات التناظرية" },
      { en: "Digital Logic", ar: "المنطق الرقمي" },
      { en: "Mathematics II", ar: "الرياضيات ٢" },
      { en: "Electromagnetic Fields", ar: "المجالات الكهرومغناطيسية" },
      { en: "Programming for Engineers", ar: "البرمجة للمهندسين" },
      { en: "Network Fundamentals", ar: "أساسيات الشبكات" },
      { en: "Electronic Devices", ar: "الأجهزة الإلكترونية" },
      { en: "Measurement Techniques", ar: "تقنيات القياس" },
      { en: "Digital Systems", ar: "الأنظمة الرقمية" },
      { en: "Communication Principles", ar: "مبادئ الاتصالات" },

      // Communication Level 3 - 12 subjects
      { en: "Communication Systems", ar: "أنظمة الاتصالات" },
      { en: "Electromagnetics", ar: "الكهرومغناطيسية" },
      { en: "Microprocessors", ar: "المعالجات الدقيقة" },
      { en: "Digital Signal Processing", ar: "معالجة الإشارات الرقمية" },
      { en: "Control Systems", ar: "أنظمة التحكم" },
      { en: "Antenna Theory", ar: "نظرية الهوائيات" },
      { en: "RF Engineering", ar: "هندسة الترددات الراديوية" },
      { en: "Data Communication", ar: "اتصالات البيانات" },
      { en: "Wireless Communication", ar: "الاتصالات اللاسلكية" },
      { en: "Information Theory", ar: "نظرية المعلومات" },
      { en: "VLSI Design", ar: "تصميم الدوائر المتكاملة" },
      { en: "Stochastic Processes", ar: "العمليات العشوائية" },

      // Communication Level 4 - 12 subjects
      { en: "Wireless Networks", ar: "الشبكات اللاسلكية" },
      { en: "Microwave Engineering", ar: "هندسة الموجات الدقيقة" },
      { en: "Optical Communication", ar: "الاتصالات البصرية" },
      { en: "Network Protocols", ar: "بروتوكولات الشبكات" },
      { en: "Embedded Systems", ar: "الأنظمة المدمجة" },
      { en: "Digital Image Processing", ar: "معالجة الصور الرقمية" },
      { en: "Radar Systems", ar: "أنظمة الرادار" },
      { en: "Coding Theory", ar: "نظرية الترميز" },
      { en: "Satellite Communication", ar: "الاتصالات عبر الأقمار الصناعية" },
      { en: "Network Security", ar: "أمن الشبكات" },
      { en: "IoT Communication", ar: "اتصالات إنترنت الأشياء" },
      { en: "5G Technologies", ar: "تكنولوجيا الجيل الخامس" },

      // Communication Level 5 - 12 subjects
      { en: "Satellite Communication", ar: "الاتصالات عبر الأقمار الصناعية" },
      { en: "Signal Processing Applications", ar: "تطبيقات معالجة الإشارات" },
      { en: "Mobile Networks", ar: "شبكات المحمول" },
      { en: "Project in Communication", ar: "مشروع في الاتصالات" },
      { en: "Communication Ethics", ar: "أخلاقيات الاتصالات" },
      { en: "Advanced Wireless Systems", ar: "الأنظمة اللاسلكية المتقدمة" },
      { en: "Network Design", ar: "تصميم الشبكات" },
      { en: "Cognitive Radio", ar: "الراديو المعرفي" },
      { en: "Telecom Management", ar: "إدارة الاتصالات" },
      { en: "Error Control Coding", ar: "ترميز التحكم بالأخطاء" },
      { en: "Communication Entrepreneurship", ar: "ريادة أعمال الاتصالات" },
      {
        en: "Emerging Communication Technologies",
        ar: "تكنولوجيا الاتصالات الناشئة",
      },

      // Civil Level 2 - 12 subjects
      { en: "Engineering Drawing", ar: "الرسم الهندسي" },
      { en: "Surveying", ar: "المساحة" },
      { en: "Mechanics of Materials", ar: "ميكانيكا المواد" },
      { en: "Geology", ar: "الجيولوجيا" },
      { en: "Fluid Mechanics", ar: "ميكانيكا الموائع" },
      { en: "Engineering Mathematics", ar: "الرياضيات الهندسية" },
      { en: "Construction Materials", ar: "مواد البناء" },
      { en: "Statics", ar: "الإستاتيكا" },
      { en: "Dynamics", ar: "الديناميكا" },
      {
        en: "CAD for Civil Engineers",
        ar: "التصميم بالحاسوب للمهندسين المدنيين",
      },
      { en: "Environmental Science", ar: "العلوم البيئية" },
      { en: "Engineering Economics", ar: "الاقتصاد الهندسي" },

      // Civil Level 3 - 12 subjects
      { en: "Soil Mechanics", ar: "ميكانيكا التربة" },
      { en: "Hydraulics", ar: "الهيدروليكا" },
      { en: "Structural Analysis", ar: "تحليل الهياكل" },
      { en: "Reinforced Concrete Design", ar: "تصميم الخرسانة المسلحة" },
      { en: "Transportation Engineering", ar: "هندسة النقل" },
      { en: "Geotechnical Engineering", ar: "الهندسة الجيوتقنية" },
      { en: "Construction Management", ar: "إدارة الإنشاءات" },
      { en: "Water Resources", ar: "موارد المياه" },
      { en: "Concrete Technology", ar: "تكنولوجيا الخرسانة" },
      { en: "Structural Mechanics", ar: "ميكانيكا الإنشاءات" },
      { en: "Highway Engineering", ar: "هندسة الطرق" },
      { en: "Environmental Engineering", ar: "الهندسة البيئية" },

      // Civil Level 4 - 12 subjects
      { en: "Steel Structures", ar: "الهياكل الفولاذية" },
      { en: "Construction Management", ar: "إدارة الإنشاءات" },
      { en: "Foundation Engineering", ar: "هندسة الأساسات" },
      { en: "Water Resources", ar: "موارد المياه" },
      { en: "Environmental Engineering", ar: "الهندسة البيئية" },
      { en: "Earthquake Engineering", ar: "هندسة الزلازل" },
      { en: "Bridge Engineering", ar: "هندسة الجسور" },
      { en: "Pavement Design", ar: "تصميم الرصف" },
      { en: "Coastal Engineering", ar: "الهندسة الساحلية" },
      { en: "Project Scheduling", ar: "جدولة المشاريع" },
      { en: "Wastewater Treatment", ar: "معالجة مياه الصرف" },
      { en: "Geographic Information Systems", ar: "نظم المعلومات الجغرافية" },

      // Civil Level 5 - 12 subjects
      { en: "Highway Engineering", ar: "هندسة الطرق" },
      { en: "Construction Materials", ar: "مواد البناء" },
      { en: "Project Planning", ar: "تخطيط المشاريع" },
      { en: "Advanced Structural Design", ar: "تصميم الهياكل المتقدمة" },
      { en: "Graduation Project", ar: "مشروع التخرج" },
      { en: "Infrastructure Management", ar: "إدارة البنية التحتية" },
      { en: "Sustainable Construction", ar: "البناء المستدام" },
      { en: "Tunnel Engineering", ar: "هندسة الأنفاق" },
      { en: "Risk Management", ar: "إدارة المخاطر" },
      { en: "Smart Cities", ar: "المدن الذكية" },
      { en: "Advanced Geotechnics", ar: "الجيوتقنية المتقدمة" },
      { en: "Professional Practice", ar: "الممارسة المهنية" },
    ];

    const subjects = [];
    for (let i = 0; i < subject_names.length; i++) {
      subjects.push({
        subject_id: `subject_${i}`,
        subject_name: subject_names[i],
        number_of_units: faker.number.int({ min: 2, max: 3 }),
        subject_description: {
          en: `This is the description for ${subject_names[i].en}.`,
          ar: `هذا الوصف ل ${subject_names[i].ar}.`,
        },
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }

    try{
      await subject.bulkCreate(subjects);
    }catch(e){
      console.log(e);
    }
  },

  down: async (queryInterface, Sequelize) => {
    await subject.destroy({ where: {}, truncate: false });
  },
};
