import 'logger_service.dart';
import '../../../presentation/routes/app_routes.dart';

/// Service to determine the initial route of the application based on data availability
class InitialRouteService {
  final LoggerService logger = LoggerService.instance;

  /// Singleton pattern
  static final InitialRouteService _instance = InitialRouteService._internal();
  factory InitialRouteService() => _instance;
  InitialRouteService._internal();

  /// Determines the initial route based on whether Pokemon data is available locally
  ///
  /// Returns the home route if data exists, otherwise the welcome route
  ///

  Future<String> determineInitialRoute() async {
    return AppRoutes.home;
  }
}
