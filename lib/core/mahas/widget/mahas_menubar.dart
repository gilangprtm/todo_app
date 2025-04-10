import 'package:flutter/material.dart';

import '../mahas_type.dart';
import 'mahas_card.dart';

enum TextVisibility {
  hideAllText,
  hideUnselectedText,
  showAllText,
}

enum CenterButtonPosition {
  center,
  aboveCenter,
}

class MahasMenuBar extends StatefulWidget {
  final List<MenuItem> items;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color unselectedColor;
  final ValueChanged<int> onTap;
  final int selectedIndex;
  final List<Widget> pages;
  final MenuType menuType;
  final TextVisibility textVisibility;
  final bool showCenterButton;
  final bool isResponsive;
  final Widget? centerButton;
  final CenterButtonPosition centerButtonPosition;

  const MahasMenuBar({
    super.key,
    required this.items,
    required this.onTap,
    required this.pages,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor = Colors.grey,
    this.selectedIndex = 0,
    this.menuType = MenuType.normal,
    this.textVisibility = TextVisibility.showAllText,
    this.showCenterButton = false,
    this.isResponsive = false,
    this.centerButton,
    this.centerButtonPosition = CenterButtonPosition.center,
  });

  @override
  MahasMenuBarState createState() => MahasMenuBarState();
}

class MahasMenuBarState extends State<MahasMenuBar> {
  late PageController _pageController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if ((_selectedIndex - _pageController.page!).abs() > 1) {
      _pageController.jumpToPage(index);
    } else {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
    widget.onTap(index);
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    if (!widget.isResponsive) {
      return Scaffold(
        body: mobile(context),
      );
    } else {
      if (isDesktop(context)) {
        return Scaffold(
          body: desktop(context),
        );
      } else if (isTablet(context)) {
        return Scaffold(
          body: tablet(context),
        );
      } else {
        return Scaffold(
          body: mobile(context),
        );
      }
    }
  }

  Stack mobile(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  children: widget.pages,
                ),
              ),
            ),
            Container(
              color: widget.backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _buildMenuItems(),
              ),
            ),
          ],
        ),
        if (widget.showCenterButton &&
            widget.centerButton != null &&
            widget.centerButtonPosition == CenterButtonPosition.aboveCenter)
          Positioned(
            bottom: 30.0,
            left: MediaQuery.of(context).size.width / 2 -
                28.0, // Center the button
            child: Center(
              child: widget.centerButton!,
            ),
          ),
      ],
    );
  }

  Stack tablet(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: widget.pages,
        ),
        Positioned(
          bottom: 10,
          left: (MediaQuery.of(context).size.width - 500) / 2,
          child: GlassContainer(
            width: 500,
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildMenuItems(),
            ),
          ),
        ),
        if (widget.showCenterButton &&
            widget.centerButton != null &&
            widget.centerButtonPosition == CenterButtonPosition.aboveCenter)
          Positioned(
            bottom: 30.0,
            left: MediaQuery.of(context).size.width / 2 -
                28.0, // Center the button
            child: Center(
              child: widget.centerButton!,
            ),
          ),
      ],
    );
  }

  Stack desktop(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: widget.pages,
        ),
        Positioned(
          bottom: 10,
          left: (MediaQuery.of(context).size.width - 500) / 2,
          child: GlassContainer(
            width: 500,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildMenuItems(),
            ),
          ),
        ),
        if (widget.showCenterButton &&
            widget.centerButton != null &&
            widget.centerButtonPosition == CenterButtonPosition.aboveCenter)
          Positioned(
            bottom: 30.0,
            left: MediaQuery.of(context).size.width / 2 -
                28.0, // Center the button
            child: Center(
              child: widget.centerButton!,
            ),
          ),
      ],
    );
  }

  List<Widget> _buildMenuItems() {
    List<Widget> menuItems = widget.items.asMap().entries.map((entry) {
      int idx = entry.key;
      MenuItem item = entry.value;
      bool isSelected = _selectedIndex == idx;

      return Expanded(
        child: GestureDetector(
          onTap: () => _onItemTapped(idx),
          child: _buildMenuItem(item, isSelected),
        ),
      );
    }).toList();

    if (widget.showCenterButton && widget.centerButton != null) {
      List<Widget> updatedMenuItems = [];
      int centerIndex = (menuItems.length / 2).floor();

      for (int i = 0; i < menuItems.length; i++) {
        if (i == centerIndex &&
            widget.centerButtonPosition == CenterButtonPosition.center) {
          updatedMenuItems.add(Expanded(child: widget.centerButton!));
        }
        updatedMenuItems.add(menuItems[i]);
        if (i == centerIndex - 1 &&
            widget.centerButtonPosition == CenterButtonPosition.aboveCenter) {
          updatedMenuItems.add(const Expanded(child: SizedBox()));
        }
      }
      return updatedMenuItems;
    } else {
      return menuItems;
    }
  }

  Widget _buildMenuItem(MenuItem item, bool isSelected) {
    bool showText;
    switch (widget.textVisibility) {
      case TextVisibility.hideAllText:
        showText = false;
        break;
      case TextVisibility.hideUnselectedText:
        showText = isSelected;
        break;
      case TextVisibility.showAllText:
        showText = true;
    }

    switch (widget.menuType) {
      case MenuType.normal:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon,
                  color: isSelected
                      ? widget.selectedColor
                      : widget.unselectedColor,
                  size: isSelected ? 28.0 : 24.0),
              if (showText)
                Text(
                  item.title,
                  style: TextStyle(
                    color: isSelected
                        ? widget.selectedColor
                        : widget.unselectedColor,
                    fontSize: 12.0,
                  ),
                ),
            ],
          ),
        );
      case MenuType.underlined:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon,
                  color: isSelected
                      ? widget.selectedColor
                      : widget.unselectedColor,
                  size: isSelected ? 28.0 : 24.0),
              if (showText)
                Text(
                  item.title,
                  style: TextStyle(
                    color: isSelected
                        ? widget.selectedColor
                        : widget.unselectedColor,
                    fontSize: 12.0,
                  ),
                ),
              if (widget.menuType == MenuType.underlined && isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 4.0),
                  height: 2.0,
                  width: 20.0,
                  color: widget.selectedColor,
                ),
            ],
          ),
        );
      case MenuType.pill:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? widget.selectedColor!.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Icon(item.icon,
                    color: isSelected
                        ? widget.selectedColor
                        : widget.unselectedColor,
                    size: isSelected ? 28.0 : 24.0),
              ),
              if (showText)
                Text(
                  item.title,
                  style: TextStyle(
                    color: isSelected
                        ? widget.selectedColor
                        : widget.unselectedColor,
                    fontSize: 12.0,
                  ),
                ),
            ],
          ),
        );
      case MenuType.iconOnly:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(item.icon,
              color: isSelected ? widget.selectedColor : widget.unselectedColor,
              size: isSelected ? 28.0 : 24.0),
        );
    }
  }
}

class MenuItem {
  final IconData icon;
  final String title;

  MenuItem({required this.icon, required this.title});
}
