import 'package:package_info_plus/package_info_plus.dart';

class MahasConfig {
  static PackageInfo? packageInfo;
  static String appName = "";
  static int? selectedDivisi;
  static String urlApi = '';
  static bool isLaravelBackend = false;
  static bool demoLogin = false;
  static List<String> noInternetErrorMessage = [
    'A network error',
    'failed host lookup',
    'user was not linked',
    'unexpected end of stream',
    'network_error',
    'connection failed',
    'clientexception',
    'socketexception',
  ];
}
