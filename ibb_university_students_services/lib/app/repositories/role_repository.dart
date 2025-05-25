import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;
import 'package:ibb_university_students_services/app/components/pop_up_cards/alert_message_card.dart';
import 'package:ibb_university_students_services/app/components/pop_up_cards/loading_card.dart';
import 'package:ibb_university_students_services/app/models/permission_model/permission.dart';
import '../models/helper_models/result.dart';
import '../models/role_model/role.dart';
import '../services/http_provider.dart';

class RoleRepository {
  static const int _fetchError = 611;
  static const int _createError = 623;

  static Future<Result<Map<int, Role>>> fetchRoles({
    bool hardFetch = false,
  }) async {
    // if ((_levelBox?.values.isNotEmpty??true) &&(!hardFetch|| !(await checkInternetConnection())) ) {
    //   return Result(
    //     data: _levelBox?.toMap().cast<int,Level>(),
    //     statusCode: 200,
    //     hasError: false,
    //     message: "successful",
    //   );
    // }
    late Response? response;
    try {
      response = await HttpProvider.get("get-roles");
      if (response?.statusCode == 200) {
        Map<int, Role> roles = {};
        for (Map<String, dynamic> jsRoles in response?.data["data"]) {
          Role role = Role.fromJson(jsRoles);
          roles[role.id] = role;
        }
        return Result(
            data: roles,
            hasError: false,
            statusCode: response?.statusCode,
            message: response?.data["message"] ?? "error");
      }

      return Result(
          data: null,
          hasError: true,
          statusCode: response?.statusCode ?? _fetchError,
          message: response?.data["message"] ?? "error");
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _fetchError,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<Role>> createRole({
    required data,
  }) async {
    get_x.Get.dialog(
      PopUpLoadingCard(),
      barrierDismissible: false,
    );
    late Response? response;
    try {
      response = await HttpProvider.post("create-roles", data: data);
      Role? newRole;
      if (response?.statusCode == 201) {
        newRole = Role.fromJson(response?.data["data"]);
      } else if (response?.statusCode == 403) {
        await get_x.Get.dialog(PopUpAlertCard(
            response?.data["message"] ?? "UnAuthorized Action", Icons.block));
      }
      return Result(
        data: newRole,
        hasError: true,
        statusCode: response?.statusCode ?? _createError,
        message: response?.data["message"] ?? "error",
      );
    } catch (error) {
      return Result(
          hasError: true,
          statusCode: _createError,
          message: error.toString(),
          data: null);
    }
  }

  static Future<Result<Map>> fetchDashboardRole({
    int? roleId,
    String? rolename,
    int? limit,
    int? page,
    String? order,
    String? sort,
    String? search,
    bool hardFech = false,
  }) async {
    late Response? response;
    try {
      response = await HttpProvider.get(
          "get-roles-panel?orderBy=${order ?? ''}&sort=${sort ?? ''}&limit=$limit&search=$search&page=$page"); //get the url from backend
      Map<int, Role> role = {};
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsRole in response?.data["data"]) {
          role[jsRole["id"]] =
              Role.fromJson(jsRole); //get the name of id from backend
        }
        return Result(
          data: {
            "roles": role,
            "totalroles": response?.data["pagination"]
                ["totalRoles"], //get the name of total from backend
          },
          hasError: false,
          statusCode: response?.statusCode,
          message: response?.data["message"] ?? "error",
        );
      }
      return Result(
        data: {
          "roles": role,
          "totalroles": 0,
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
        data: null,
      );
    }
  }

  static Future<Result<Permission>> fetchDashbordPermition({
    required int id,
    bool hardFetch = false,
  }) async {
    late Response? response;
    try {
      response = await HttpProvider.get(
          "url"); //get the url of permition and the id is the roleid
      if (response?.statusCode == 200) {
        Permission permission = Permission.fromJson(
            response?.data["data"]); //get the id name from backend
        return Result(
          data: permission,
          hasError: false,
          statusCode: response?.statusCode,
          message: response?.data["message"] ?? "error",
        );
      }
      return Result(
        data: null,
        hasError: true,
        statusCode: response?.statusCode ?? _fetchError,
        message: response?.data["message"] ?? "error",
      );
    } catch (error) {
      return Result(
        hasError: true,
        statusCode: _fetchError,
        message: error.toString(),
        data: null,
      );
    }
  }
}
