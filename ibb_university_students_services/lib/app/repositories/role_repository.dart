import 'package:dio/dio.dart';

import '../models/helper_models/result.dart';
import '../models/role_model/role.dart';
import '../services/http_provider.dart';

class RoleRepository{
  static const int _fetchError = 611;

  static Future<Result<Map<int,Role>>> fetchRoles({
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
        Map<int,Role> roles = {};
        for (Map<String, dynamic> jsRoles in response?.data["data"]) {
          Role role = Role.fromJson(jsRoles);
          roles[role.id] = role ;
        }
        return Result(
            data:  roles,
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
}