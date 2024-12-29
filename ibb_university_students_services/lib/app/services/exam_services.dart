import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;
import 'package:ibb_university_students_services/app/components/pop_up_cards/alert_message_card.dart';
import 'package:ibb_university_students_services/app/services/subject_services.dart';
import '../components/pop_up_cards/loading_card.dart';
import '../models/exam_model.dart';
import '../models/result.dart';
import '../models/subject_model.dart';
import 'http_provider/http_provider.dart';


class ExamServices {
  static const int  _fetchAllError = 621;
  static const int  _fetchError = 622;
  static const int _createError = 623;
  static const int _updateError = 624;

  static Map<String,Map<String,Map<int,Exam>?>?>? _exams;

  static Future<Result<Map<int,Exam>>> fetchExamsGroup({
    required int sectionId,
    required int levelId,
    bool hardFetch = false,
  }) async {
    if (_exams?[sectionId.toString()]?[levelId.toString()] != null && !hardFetch) {
      return Result(
        data: _exams?[sectionId.toString()]?[levelId.toString()],
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("get-exam-grouped/$sectionId/$levelId");
      if (response?.statusCode == 200) {
        _exams ??= {};
        if(_exams?[sectionId.toString()] == null){
          _exams?[sectionId.toString()] = {};
        }
        if(_exams?[sectionId.toString()]?[levelId.toString()] == null){
          _exams?[sectionId.toString()]?[levelId.toString()] = {};
        }
        for(Map<String,dynamic> jsExam in response?.data["data"]){
          Subject? subject = await SubjectServices.fetchSubject(id: jsExam["subject_id"]).then((e){
            return e.data;
          });
          Exam exam = Exam.fromJson(jsExam,subject:subject);
          _exams?[sectionId.toString()]?[levelId.toString()]?[exam.id] = exam;
        }
        return Result(
            data: _exams?[sectionId.toString()]?[levelId.toString()],
            hasError: false,
            statusCode: response?.statusCode,
            message: response?.data["message"] ?? "error");
      }else if(response?.statusCode == 404){
        _exams?[sectionId.toString()]?[levelId.toString()]={};
        return Result(
            data: _exams?[sectionId.toString()]?[levelId.toString()],
            hasError: false,
            statusCode: response?.statusCode,
            message: response?.data["message"] ?? "error");
      }

      return Result(
          data: null,
          hasError: true,
          statusCode: response?.statusCode ?? _fetchAllError,
          message: response?.data["message"] ?? "error");

    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchAllError,
          message: error.toString(),
          data: null);
    }
  }


  static Future<Result<Exam>> createExam({
    required int sectionId,
    required int levelId,
    required data,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),barrierDismissible: false,name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.post(
          "create-exam",data: data);
      Exam? newExam;
      if (response?.statusCode == 201) {
        Subject? subject = await SubjectServices.fetchSubject(id:  response?.data["exam"]["subject_id"]).then((e)=>e.data);
        newExam = Exam.fromJson(response?.data["exam"],subject:subject);
        _exams?[sectionId.toString()]?[levelId.toString()]?[newExam.id] = newExam;
      }else if(response?.statusCode == 403){
        await get_x.Get.dialog(PopUpAlertCard(response?.data["message"]??"UnAuthorized Action", Icons.block));
      }
      return Result(
          data: newExam,
          hasError: true,
          statusCode: response?.statusCode ?? _createError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _createError,
          message: error.toString(),
          data: null);
    }
  }


  static Future<Result<Exam>> updateExam({
    required int sectionId,
    required int levelId,
    required data,
    required id,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),barrierDismissible: false,name: "loadingDialog");
    late Response? response;
    try {
      response = await HttpProvider.put(
          "update-exam/$id",data: data);
      Exam? newExam;
      print(response?.data);
      if (response?.statusCode == 200) {
        Subject? subject = await SubjectServices.fetchSubject(id:  response?.data["exam"]["subject_id"]).then((e)=>e.data);
        newExam = Exam.fromJson(response?.data["exam"],subject:subject);
        _exams?[sectionId.toString()]?[levelId.toString()]?[newExam.id] = newExam;
      }else if(response?.statusCode == 403){
        await get_x.Get.dialog(PopUpAlertCard(response?.data["message"]??"UnAuthorized Action", Icons.block));
      }
      return Result(
          data: newExam,
          hasError: true,
          statusCode: response?.statusCode ?? _updateError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _updateError,
          message: error.toString(),
          data: null);
    }
  }





}
