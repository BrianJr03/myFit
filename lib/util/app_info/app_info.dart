import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static String name = "";
  static String packageName = "";
  static String version = "";
  static String buildNumber = "";
  static void init() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      name = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }
}
