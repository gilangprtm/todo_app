import 'package:flutter/material.dart';

class MahasGrid extends StatelessWidget {
  final List<Widget> items;
  final int crossAxisCount;
  final double childAspectRatio;
  final Axis scrollDirection;
  final EdgeInsets padding;

  const MahasGrid({
    super.key,
    required this.items,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.scrollDirection = Axis.vertical,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      scrollDirection: scrollDirection,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }
}
