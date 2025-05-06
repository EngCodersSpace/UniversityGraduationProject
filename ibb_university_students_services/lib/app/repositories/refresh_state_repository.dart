import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../models/helper_models/result.dart';
import '../models/refrech_state_model/refresh_state.dart';
import '../utils/internet_connection_cheker.dart';
import '../services/http_provider.dart';

class RefreshStateRepository {
  static const int _fetchAllError = 621;

  // ignore: unused_field
  static const int _fetchError = 622;


  static Box<RefreshState>? _refreshState;

  static Future<void> openBox() async {
    _refreshState = await Hive.openBox<RefreshState>("RefreshState");
  }

  static Future<void> clearBox() async {
    _refreshState = await Hive.openBox<RefreshState>("RefreshState");
    _refreshState?.clear();
  }

  static Future<void> closeBox() async {
    if (_refreshState?.isOpen ?? false) {
      await _refreshState?.close();
    }
  }

  static Future<Result> fetchCachedRefreshStateRecord({
    required int id,
  }) async {
    RefreshState? refreshState = _refreshState?.get(id);
    return Result(
      data: refreshState,
      statusCode: 200,
      hasError: false,
      message: "successful",
    );
  }

  static Future<void> cacheRefreshStateRecord({
    required RefreshState state,
  }) async {
   await  _refreshState?.put(state.id,state) ;

  }

  static Future<Result> fetchLastRefreshStates() async {

    if ((!(await checkInternetConnection()))) {
      return Result(
        data: null,
        statusCode: 700,
        hasError: false,
        message: "no connection",
      );
    }
    late Response? response;
    try {
      response = await HttpProvider.get("");
      if (response?.statusCode == 200) {
        return Result(
            data: null,
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
}
