import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/permission_model/permission.dart';
import '../models/helper_models/result.dart';
import '../models/role_model/role.dart';
import '../services/http_provider.dart';
import '../utils/internet_connection_cheker.dart';

class RoleRepository {
  static const int _fetchError = 611;

  static Box<Role>? _roleBox;

  static Future<void> openBox() async {
    if(_roleBox?.isOpen??false)return;
    _roleBox = await Hive.openBox<Role>('RoleBox');
    // Box  = await Hive.openBox('');
  }
  static Future<void> clearBox() async {
    _roleBox = await Hive.openBox<Role>('RoleBox');
    _roleBox?.clear();
  }

  static Future<void> closeBox() async {
    if(_roleBox?.isOpen??false) {
      await _roleBox?.close();
    }
  }
  static Future<Result<Map<int, Role>>> fetchRoles({
    bool hardFetch = false,
  }) async {
    await openBox();
    if ((_roleBox?.values.isNotEmpty??false) &&(!hardFetch|| !(await checkInternetConnection())) ) {
      return Result(
        data: _roleBox?.toMap().cast<int,Role>(),
        statusCode: 200,
        hasError: false,
        message: "successful",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("get-roles");
      if (response?.statusCode == 200) {
        for (Map<String, dynamic> jsRoles in response?.data["data"]) {
          Role role = Role.fromJson(jsRoles);
          await _roleBox?.put(role.id, role);

        }
        return Result(
            data: _roleBox?.toMap().cast<int,Role>(),
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

  static Future<Result<Map>> fetchDashboardRole({
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
          "get-roles-panel?roleName=${rolename ?? ''}&orderBy=${order ?? ''}&sort=${sort ?? ''}&limit=$limit&search=$search&page=$page"); //get the url from backend
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
