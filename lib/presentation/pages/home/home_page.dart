import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/mahas/mahas_type.dart';
import '../../../core/mahas/widget/mahas_menubar.dart';
import '../../../core/mahas/widget/mahas_bottomsheet.dart';
import '../../../core/theme/app_color.dart';
import '../../providers/home/home_provider.dart';
import '../task/task_page.dart';
import '../calendar/calendar_page.dart';
import '../stats/stats_page.dart';
import '../settings/settings_page.dart';
import '../add_task/add_task_page.dart';

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
      items: menuItems,
      pages: pages,
      onTap: notifier.changeMenu,
      selectedIndex: state.selectedMenuIndex,
      menuType: MenuType.iconOnly,
      backgroundColor: AppColors.ghibliCream,
      selectedColor: AppColors.notionBlack,
      unselectedColor: AppColors.notionBlack.withAlpha(120),
      showCenterButton: true,
      centerButton: FloatingActionButton(
        onPressed: () {
          MahasBottomSheet.show(
            context: context,
            title: 'Add New Task',
            height: MediaQuery.of(context).size.height * 0.55,
            child: const AddTaskPage(),
          );
        },
        backgroundColor: AppColors.notionBlack,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      centerButtonPosition: CenterButtonPosition.aboveCenter,
    );
  }
}
