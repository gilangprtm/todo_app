import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/mahas/mahas_type.dart';
import '../../../core/mahas/widget/mahas_menubar.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/utils/mahas.dart';
import '../../providers/home/home_provider.dart';
import '../../routes/app_routes.dart';
import '../task/task_page.dart';
import '../calendar/calendar_page.dart';
import '../stats/stats_page.dart';
import '../settings/settings_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);

    // Define menu items
    final List<MenuItem> menuItems = [
      MenuItem(icon: Icons.home_outlined, title: 'Home'),
      MenuItem(icon: Icons.calendar_today_outlined, title: 'Calendar'),
      MenuItem(icon: Icons.bar_chart_outlined, title: 'Stats'),
      MenuItem(icon: Icons.settings_outlined, title: 'Settings'),
    ];

    // Define pages for each menu item
    final List<Widget> pages = [
      const TaskPage(),
      const CalendarPage(),
      const StatsPage(),
      const SettingsPage(),
    ];

    return MahasMenuBar(
      bottomPadding: 0,
      items: menuItems,
      pages: pages,
      onTap: notifier.changeMenu,
      selectedIndex: state.selectedMenuIndex,
      menuType: MenuType.iconOnly,
      textVisibility: TextVisibility.hideAllText,
      backgroundColor: AppColors.getCardColor(context).withValues(alpha: 0.8),
      selectedColor: AppColors.getTextPrimaryColor(context),
      unselectedColor: AppColors.getTextSecondaryColor(context),
      showCenterButton: true,
      centerButton: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.getTextPrimaryColor(context),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.getTextPrimaryColor(
                context,
              ).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.add, size: 30),
          color: AppColors.getCardColor(context),
          onPressed: () {
            Mahas.routeTo(AppRoutes.addTask);
          },
        ),
      ),
      centerButtonPosition: CenterButtonPosition.center,
    );
  }
}
