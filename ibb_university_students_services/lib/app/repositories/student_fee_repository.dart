import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart' as get_x;
import 'package:ibb_university_students_services/app/models/helper_models/students_fee_cache/student_fee_cache.dart';
import '../components/pop_up_cards/alert_message_card.dart';
import '../components/pop_up_cards/loading_card.dart';
import '../models/helper_models/result.dart';
import '../models/student_fee/student_fee.dart';
import '../utils/internet_connection_cheker.dart';
import '../services/http_provider.dart';

class StudentFeeRepository {
  static const int _fetchAllError = 611;

  // ignore: unused_field
  static const int _fetchError = 611;
  static const int _createError = 612;
  static const int _updateError = 612;
  static const int _deleteError = 612;

  static Box<StudentFeeCache>? _studentFeeBox;

  static Future<void> openBox() async {
    _studentFeeBox = await Hive.openBox<StudentFeeCache>("studentFeeBox");
    _studentFeeBox?.clear();
  }

  static Future<void> clearBox() async {
    _studentFeeBox = await Hive.openBox<StudentFeeCache>("studentFeeBox");
    _studentFeeBox?.clear();
  }

  static Future<void> closeBox() async {
    if (_studentFeeBox?.isOpen ?? false) {
      await _studentFeeBox?.close();
    }
    if (Hive.isBoxOpen("lastStudentFee")) {
      await Hive.box("lastStudentFee").close();
    }
  }

  static Future<Result<Map<int, StudentFee>>> fetchStudentFees({
    required int studentId,
    bool hardFetch = false,
  }) async {
    if ((_studentFeeBox?.get(studentId)?.data.values.isNotEmpty ?? false) &&
        (!hardFetch || !(await checkInternetConnection()))) {
      return Result(
          data: _studentFeeBox?.get(studentId)?.data,
          hasError: false,
          statusCode: 200);
    }
    late Response? response;
    try {
      response = await HttpProvider.get("get-allFeeOfStudent",
          data: {"student_id": studentId});
      if (response?.statusCode == 200) {
        StudentFeeCache cachedFees = StudentFeeCache(key: studentId, data: {});
        for (Map<String, dynamic> jsFee in response?.data["Fees"] ?? {}) {
          StudentFee fee = StudentFee.fromJson(jsFee);
          cachedFees.data[fee.id] = fee;
          await _studentFeeBox?.put(
            studentId,
            cachedFees,
          );
        }
        return Result(
            data: cachedFees.data,
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

  static Future<Result<StudentFee>> fetchLastStudentFee({
    required int studentId,
    bool hardFetch = false,
  }) async {
    late Response? response;
    try {
      Box lastFeeBox = await Hive.openBox<StudentFee>("lastStudentFee");
      if ((lastFeeBox.get("$studentId") != null) &&
          (!hardFetch || !(await checkInternetConnection()))) {
        lastFeeBox.close();
        return Result(
            data: lastFeeBox.get("$studentId"),
            hasError: false,
            statusCode: 200);
      }
      response = await HttpProvider.get("get-allFeeOfStudent-orderd");
      StudentFee? newStudentFee;
      if (response?.statusCode == 200) {
        newStudentFee = StudentFee.fromJson(response?.data["lastPayment"]);
        await lastFeeBox.put(studentId, newStudentFee);
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      lastFeeBox.close();
      return Result(
          data: newStudentFee,
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

  static Future<Result<StudentFee>> createStudentFee({
    required int studentId,
    required data,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(), barrierDismissible: false);
    late Response? response;
    try {
      response = await HttpProvider.post("create-student-fee", data: data);
      StudentFee? newStudentFee;
      if (response?.statusCode == 201) {
        newStudentFee = StudentFee.fromJson(response?.data["Fee"]);
        StudentFeeCache? cachedFees = _studentFeeBox?.get(studentId);
        cachedFees?.data[newStudentFee.id] = newStudentFee;
        if (cachedFees != null) {
          await _studentFeeBox?.put(studentId, cachedFees);
        }
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: newStudentFee,
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

  static Future<Result<StudentFee>> updateStudentFee({
    required int studentId,
    required id,
    required data,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    StudentFeeCache? cachedFees = _studentFeeBox?.get(studentId);
    try {
      response = await HttpProvider.put("update-fee", data: data);
      if (response?.statusCode == 200) {
        cachedFees?.data[id] = StudentFee.fromJson(response?.data["data"]);
        if (cachedFees != null) {
          await _studentFeeBox?.put(studentId, cachedFees);
        }
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          data: cachedFees?.data[id],
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

  static Future<Result<void>> deleteStudentFee({
    required int studentId,
    required id,
    bool hardFetch = false,
  }) async {
    get_x.Get.dialog(const PopUpLoadingCard(),
        barrierDismissible: false, name: "loadingDialog");
    late Response? response;
    try {
      StudentFeeCache? cachedFees = _studentFeeBox?.get(studentId);

      response = await HttpProvider.delete("delete-fee?id=$id");
      if (response?.statusCode == 200) {
        cachedFees?.data.remove(id);
        if (cachedFees != null) {
          await _studentFeeBox?.put(studentId, cachedFees);
        }
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
          hasError: false,
          statusCode: response?.statusCode ?? _deleteError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _deleteError,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<Map>> fetchDashboardPayment({
    int? studentId,
    int? levelId,
    String? term,
    int? totalAmount,
    int? amountPaid,
    int? remainAmount,
    String? receiptNum,
    int? page,
    int? limit,
    String? order,
    String? sort,
    String? search,
    bool hardFetch = false,
  }) async {
    late Response? response;
    try {
      response = await HttpProvider.get(
          "get-Fees-panle?student_id=${studentId ?? ''}&level_fees_id=${levelId ?? ''}&term=${term ?? ''}&total_amount=${totalAmount ?? ''}&amount_paid=${amountPaid ?? ''}&remaining_amount=${remainAmount ?? ''}&receipt_number=${receiptNum ?? ''}&order=${order ?? ''}&sort=${sort ?? ''}&limit=$limit&page=$page&seadrch=$search"); //the url from post man
      Map<int, StudentFee>? studentFee = {};
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsStudentfee in response?.data['data']) {
          studentFee[jsStudentfee["id"]] = StudentFee.fromJson(jsStudentfee);
        }
        return Result(
          data: {
            "studentFee": studentFee,
            "totalStudentFee": response?.data["pagination"]["totalStudentFees"],
          },
          hasError: false,
          statusCode: response?.statusCode,
          message: response?.data["message"] ?? "error",
        );
      }
      return Result(
        data: {
          "studentFee": studentFee,
          "totalStudentFee": 0,
        },
        hasError: false,
        statusCode: response?.statusCode,
        message: response?.data["message"] ?? "error",
      );
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchError,
          message: error.toString(),
          data: null);
    }
  }
}
