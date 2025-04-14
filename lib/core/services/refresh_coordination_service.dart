/// Service untuk mengkoordinasikan refresh antar halaman
/// Mencegah refresh berulang dalam waktu singkat
class RefreshCoordinationService {
  // Singleton pattern
  static final RefreshCoordinationService _instance =
      RefreshCoordinationService._internal();
  factory RefreshCoordinationService() => _instance;
  RefreshCoordinationService._internal();

  // Tracking waktu terakhir refresh untuk masing-masing entity
  final Map<String, DateTime> _lastRefreshTimestamp = {};

  // Minimal interval antar refresh (5 detik)
  static const Duration minRefreshInterval = Duration(seconds: 5);

  // Check apakah entity boleh di-refresh
  bool shouldRefresh(String entityKey) {
    final now = DateTime.now();
    final lastRefresh = _lastRefreshTimestamp[entityKey] ?? DateTime(2000);

    return now.difference(lastRefresh) > minRefreshInterval;
  }

  // Update timestamp refresh
  void markRefreshed(String entityKey) {
    _lastRefreshTimestamp[entityKey] = DateTime.now();
  }
}
