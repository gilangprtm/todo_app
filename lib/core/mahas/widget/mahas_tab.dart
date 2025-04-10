import 'package:flutter/material.dart';

// Original MahasTabBar for standard tabs
class MahasTabBar extends StatelessWidget {
  final List<Tab> tabs;
  final List<Widget> tabViews;
  final Color? labelColor;

  const MahasTabBar({
    super.key,
    required this.tabs,
    required this.tabViews,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          tabs: tabs,
          labelColor: labelColor,
          unselectedLabelColor: Colors.grey,
        ),
        Expanded(
          child: TabBarView(
            children: tabViews,
          ),
        ),
      ],
    );
  }
}

// New pill-shaped tab bar design
class MahasPillTabBar extends StatelessWidget {
  final List<String> tabLabels;
  final List<Widget> tabViews;
  final ValueChanged<int>? onTabChanged;
  final int initialIndex;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const MahasPillTabBar({
    super.key,
    required this.tabLabels,
    required this.tabViews,
    this.onTabChanged,
    this.initialIndex = 0,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.transparent,
    this.backgroundColor = Colors.grey,
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = Colors.black87,
    this.height = 48.0,
    this.borderRadius = 24.0,
    this.padding = const EdgeInsets.all(4.0),
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabLabels.length,
      initialIndex: initialIndex,
      child: Column(
        children: [
          // Custom pill-shaped tab bar
          Container(
            height: height,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(borderRadius - 4),
              ),
              labelColor: activeTextColor,
              unselectedLabelColor: inactiveTextColor,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w400),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              onTap: onTabChanged,
              tabs: tabLabels.map((label) => Tab(text: label)).toList(),
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              children: tabViews,
            ),
          ),
        ],
      ),
    );
  }
}
