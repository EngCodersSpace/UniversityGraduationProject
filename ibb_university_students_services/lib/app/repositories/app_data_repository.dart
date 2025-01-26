class AppDataServices {
  // ignore: unused_field
  static const int _fetchError = 611;

  // static Future<Result<bool>> fetchAppData() async {
  //   late Response? response;
  //   try {
  //     response = await HttpProvider.get("all-data");
  //     if (response?.statusCode == 200) {
  //       Map<String,Subject> subjects = {};
  //
  //       for (Map<String, dynamic> jsSubject in response?.data["data"]["subjects"]) {
  //         subjects[jsSubject["subject_id"]]=Subject.fromJson(jsSubject);
  //       }
  //       SubjectRepository.cacheSubjects(subjects);
  //
  //       //
  //       // Map<int,Section> sections = {};
  //       // for (Map<String, dynamic> jsSection in response?.data["data"]["sections"]) {
  //       //   sections[jsSection["id"]]=Section.fromJson(jsSection);
  //       // }
  //       // SectionServices.cacheSections(sections);
  //       // Map<int,Level> levels = {};
  //       // for (Map<String, dynamic> jsLevel in response?.data["data"]["levels"]) {
  //       //
  //       //   levels[jsLevel["id"]]= Level.fromJson(jsLevel);
  //       // }
  //       // LevelServices.cacheLevels(levels);
  //
  //
  //       return Result(
  //           data: true,
  //           hasError: true,
  //           statusCode: response?.statusCode ?? _fetchError,
  //           message: response?.data["message"] ?? "error");
  //     }
  //
  //     return Result(
  //         data: false,
  //         hasError: true,
  //         statusCode: response?.statusCode ?? _fetchError,
  //         message: response?.data["message"] ?? "error");
  //   } catch (error) {
  //     return Result(
  //         hasError: true,
  //         statusCode: _fetchError,
  //         message: error.toString(),
  //         data: null);
  //   }
  // }
}
