class FlutterBackgroundServiceIos{

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onBackground: (_) => true,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
      ),
    );

    service.startService();
  }

  static void onStart(ServiceInstance service) {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Background Service",
        content: "Uploading & Downloading...",
      );
    }

    service.on("startDownload").listen((data) {
      startDownload(data!["url"], data["savePath"]);
    });

    service.on("startUpload").listen((data) {
      startUpload(data!["filePath"], data["uploadUrl"]);
    });
}