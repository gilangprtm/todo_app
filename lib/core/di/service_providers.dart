import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/local/db/db_local.dart';
import '../../data/datasource/local/services/onboarding_service.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  final db = DBLocal();
  return OnboardingService(db: db);
});
