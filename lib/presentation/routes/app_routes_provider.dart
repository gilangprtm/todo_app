import '../pages/home/home_page.dart';

import 'package:flutter/material.dart';
import '../pages/onboarding/onboarding_page.dart';
import '../pages/calendar/calendar_page.dart';
import 'app_routes.dart';

class AppRoutesProvider {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //
      AppRoutes.home: (context) => const HomePage(),
      AppRoutes.onboarding: (context) => const OnboardingPage(),
      AppRoutes.calendar: (context) => const CalendarPage(),

      // The Pokemon detail page needs parameters, so it will be created using Navigator.push
      // directly from the home page. This route is just for reference or deep linking.
    };
  }
}
