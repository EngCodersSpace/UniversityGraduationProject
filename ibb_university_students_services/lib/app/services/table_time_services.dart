import '../models/result.dart';
import '../models/student_model.dart';


class TableTimeServices {

  static Future<Result<Student>> fetchTableTime({bool hardFetch = false}) async {
    return Result(hasError: true, message: "error");
  }

  static void write() {}
}
