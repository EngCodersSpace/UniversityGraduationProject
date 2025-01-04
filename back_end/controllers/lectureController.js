const { validationResult } = require("express-validator");
const { lecture, subject, doctor, section, level, user } = require("../models");
const { Sequelize } = require("sequelize");
// const { } = require('../middleware/helperLecture');
const { Op } = require("sequelize");
const cron = require("node-cron");

const createLecture = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    const newLecture = await lecture.create(req.body);
    res.status(201).json({
      message: "Lecture created successfully",
      data: newLecture,
    });
  } catch (error) {
    console.error("Error creating lecture:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

const getNextLectureDay = (lectureDay) => {
  const today = new Date();
  const dayOfWeek = today.getDay();
  const daysMap = {
    Sunday: 0,
    Monday: 1,
    Tuesday: 2,
    Wednesday: 3,
    Thursday: 4,
    Friday: 5,
    Saturday: 6,
  };
  const lectureDayNumber = daysMap[lectureDay];
  const daysUntilLecture = (lectureDayNumber - dayOfWeek + 7) % 7 || 7;
  const nextLectureDate = new Date(today);
  nextLectureDate.setDate(today.getDate() + daysUntilLecture);
  return nextLectureDate;
};

async function restoreOriginalLecture(originalLectureId) {
  try {
    const originalLecture = await lecture.findByPk(originalLectureId);
    if (originalLecture && originalLecture.isReplaced) {
      await originalLecture.update({ isReplaced: false });
      console.log(`Restored the original lecture: ${originalLectureId}`);
    }
  } catch (error) {
    console.error("Error restoring original lecture:", error);
  }
}

const replaceOne = async (req, res) => {
  const transaction = await lecture.sequelize.transaction();
  try {
    const originalLecture = await lecture.findByPk(req.query.id);
    if (!originalLecture) {
      throw new Error("Original lecture not found");
    }

    originalLecture.isReplaced = true;
    await originalLecture.save({ transaction });

    const updateFields = {
      originalLecturId: req.query.id,
      lecture_section_id: originalLecture.lecture_section_id,
      lecture_level_id: originalLecture.lecture_level_id,
      term: originalLecture.term,
      year: originalLecture.year,
      subject_id: req.body.subject_id || originalLecture.subject_id,
      doctor_id: req.body.doctor_id || originalLecture.doctor_id,
      lecture_time: req.body.lecture_time || originalLecture.lecture_time,
      lecture_duration:req.body.lecture_duration || originalLecture.lecture_duration,
      lecture_day: req.body.lecture_day || originalLecture.lecture_day,
      lecture_room: req.body.lecture_room || originalLecture.lecture_room,
    };
    const replacedLecture = await lecture.create(updateFields, { transaction });

    
    const nextLectureDay = getNextLectureDay(originalLecture.lecture_day);
    const [hours, minutes, seconds] = originalLecture.lecture_time
      .split(":")
      .map(Number);
    nextLectureDay.setHours(hours, minutes, seconds, 0);
    const lectureStartTime = nextLectureDay;
    const lectureEndTime = new Date(
      lectureStartTime.getTime() + originalLecture.lecture_duration * 60000
    );

    // Calculate the remaining time
    // const remainingTime = lectureEndTime.getTime() - new Date().getTime();
    // cron.schedule(`*/${remainingTime / 60000} * * * *`, () => {
    //   restoreOriginalLecture(req.body.originalLectureId);
    //   replacedLecture.destroy();
    // });

    // Set a timeout for restoring the original lecture
    cron.schedule(`*/5 * * * *`, async () => {
      const now = new Date().getTime();
      if (now >= lectureEndTime.getTime()) {
        await restoreOriginalLecture(req.body.originalLectureId);
        await replacedLecture.destroy();
      }
    });
    await transaction.commit();
    return res
      .status(200)
      .json({ message: "Lecture replaced successfully", replacedLecture });
  } catch (error) {
    await transaction.rollback();
    console.error("Error during lecture replacement:", error);
    return res
      .status(500)
      .json({ message: "Failed to replace lecture", error: error.message });
  }
};

const changeLecStatus = async (req, res) => {
  if (req.body.action !== "confirm" && req.body.action !== "cancel") {
    return res
      .status(400)
      .json({ message: 'Invalid action. Use either "confirm" or "cancel".' });
  }
  const lectureCancled = await lecture.findByPk(req.body.id);
  if (!lectureCancled) {
    return res.status(404).json({ message: "Lecture not found" });
  }
  try {
    lectureCancled.lectureStatus = req.body.action === "confirm";
    await lectureCancled.save();
    return res
      .status(200)
      .json({ message: `Lecture ${req.body.action}ed successfully` });
  } catch (error) {
    console.error("Error during lecture status update:", error);
    return res
      .status(500)
      .json({
        message: "Failed to update lecture status",
        error: error.message,
      });
  }
};

const updateLecture = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    await lecture.update(req.body, {
      where: { id: req.query.id },
      returning: true,
    });

    res.status(200).json({
      message: "Lecture updated successfully",
    });
  } catch (error) {
    console.error("Error creating lecture:", error.message);
    res
      .status(500)
      .json({ message: "Internal server error", error: error.message });
  }
};

const deleteLecture = async (req, res) => {
  try {
    const deleted = await lecture.destroy({
      where: { id: req.query.id },
    });

    if (deleted === 0) {
      return res.status(404).json({ message: "Lecture not found" });
    }

    res.status(200).json({
      message: "Lecture deleted successfully",
    });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Error deleting lecture", error: error.message });
  }
};

// To get all lectures
const getLectures = async (req, res) => {
  try {
    const lectures = await lecture.findAll({
      attributes: [
        "id",
        "subject_id",
        "lecture_time",
        "lecture_duration",
        "lecture_room",
      ],
      include: [
        {
          model: doctor,
          as: "doctor",
          attributes: ["doctor_id"],
          include: [
            {
              model: user,
              as: "user",
              attributes: ["user_name"],
            },
          ],
        },
      ],
    });

    res.status(200).json({ message: "getAllLectures", data: lectures });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Error retrieving lectures", error: error.message });
  }
};

// To get lectures by searching => (section_id, level_id, year , term , day) ||  without searching
const getLecturesGroupedByCriteria = async (req, res) => {
  try {
    const { section_id, level_id, year, term, day } = req.query;

    const whereClause = {};
    if (section_id) whereClause.lecture_section_id = section_id;
    if (level_id) whereClause.lecture_level_id = level_id;
    if (year) whereClause.year = year;
    if (term) whereClause.Term = term;
    if (day) whereClause.lecture_day = day;

    const lectures = await lecture.findAll({
      where: {
        [Op.and]: [
          whereClause,
          {
            isReplaced: {
              [Op.ne]: true,
            },
          },
        ],
      },
      include: [
        { model: subject, as: "subject" },
        { model: section, as: "section" },
        { model: level, as: "level" },
      ],
    });

    if (!lectures.length) {
      return res
        .status(404)
        .json({ message: "No lectures found for the specified criteria" });
    }

    const organizedLectures = {};

    lectures.forEach((lec) => {
      const term = lec.term;
      const day = lec.lecture_day;

      if (!organizedLectures[term]) {
        organizedLectures[term] = {};
      }

      if (!organizedLectures[term][day]) {
        organizedLectures[term][day] = [];
      }

      organizedLectures[term][day].push({
        id: lec.id,
        subject_id: lec.subject_id,
        lecture_time: lec.lecture_time,
        lecture_duration: lec.lecture_duration,
        doctor_id: lec.doctor_id,
        lecture_room: lec.lecture_room,
        lectureStatus: lec.lectureStatus,
      });
    });

    res
      .status(200)
      .json({
        message: "Lectures retrieved successfully",
        data: organizedLectures,
      });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Error retrieving lectures", error: error.message });
  }
};

// To get All years in lecture table (without duplicate)
const getLectureYear = async (req, res) => {
  try {
    const uniqueYears = await lecture.findAll({
      attributes: [[Sequelize.fn("DISTINCT", Sequelize.col("year")), "year"]],
      raw: true,
    });

    if (uniqueYears.length === 0) {
      return res
        .status(404)
        .json({ message: "No unique years found in the lecture table" });
    }

    const years = uniqueYears.map((item) => item.year);

    res
      .status(200)
      .json({ message: "Unique years retrieved successfully", data: years });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Error retrieving unique years", error: error.message });
  }
};

// To get lectures for a specific doctor
const getDoctorLectures = async (req, res) => {
  try {
    const lectures = await lecture.findAll({
      where: { doctor_id: req.user.user_id },
      include: [
        { model: subject, as: "subject", attributes: ["subject_name"] },
        { model: section, as: "section", attributes: ["section_name"] },
        { model: level, as: "level", attributes: ["level_name"] },
      ],
    });

    if (!lectures.length) {
      return res
        .status(404)
        .json({ message: "No lectures found for this doctor" });
    }

    const organizedLectures = {};
    lectures.forEach((lec) => {
      const term = lec.term;
      const day = lec.lecture_day;

      if (!organizedLectures[term]) {
        organizedLectures[term] = {};
      }
      if (!organizedLectures[term][day]) {
        organizedLectures[term][day] = [];
      }

      organizedLectures[term][day].push({
        id: lec.id,
        subject: lec.subject,
        startTime: lec.lecture_time,
        duration: lec.lecture_duration,
        lecture_room: lec.lecture_room,
      });
    });

    res.status(200).json({
      message: "Lectures retrieved successfully",
      data: organizedLectures,
    });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ message: "Error retrieving lectures", error: error.message });
  }
};

module.exports = {
  createLecture,
  getLectures,
  updateLecture,
  deleteLecture,
  getLecturesGroupedByCriteria,
  getLectureYear,
  getDoctorLectures,
  replaceOne,
  changeLecStatus,
};