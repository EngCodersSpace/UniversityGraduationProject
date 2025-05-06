import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:ibb_university_students_services/app/models/data_sync/data_sync.dart';
import '../models/helper_models/result.dart';
import '../utils/internet_connection_cheker.dart';
import '../services/http_provider.dart';

class DataSyncRepository {
  static const int _fetchAllError = 621;

  // ignore: unused_field
  static const int _fetchError = 622;

  static Box<DataSync>? _dataSync;

  static Future<void> openBox() async {
    _dataSync = await Hive.openBox<DataSync>("RefreshState");
  }

  static Future<void> clearBox() async {
    _dataSync = await Hive.openBox<DataSync>("RefreshState");
    _dataSync?.clear();
  }

  static Future<void> closeBox() async {
    if (_dataSync?.isOpen ?? false) {
      await _dataSync?.close();
    }
  }

  static Future<Result> fetchCachedDataSyncRecord({
    required String id,
  }) async {
    DataSync? refreshState = _dataSync?.get(id);
    return Result(
      data: refreshState,
      statusCode: 200,
      hasError: false,
      message: "successful",
    );
  }

  static Future<void> cacheDataSyncRecord({
    required DataSync state,
  }) async {
    await _dataSync?.put(state.id, state);
  }

  static Future<Result<Map<String,DataSync>>> fetchLastDataSyncs() async {
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
      response = await HttpProvider.get("get-all-refresh");
      if (response?.statusCode == 200) {
        Map<String,DataSync> dataSyncs = {};
        for(Map<String, dynamic> jsDataSync in response?.data["data"]){
          dataSyncs[jsDataSync['id']] = DataSync.fromJson(jsDataSync);
        }
        return Result(
            data: dataSyncs,
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
