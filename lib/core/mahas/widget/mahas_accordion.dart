import 'package:flutter/material.dart';

import '../mahas_type.dart';

class MahasAccordion extends StatefulWidget {
  final String title;
  final Widget content;
  final bool initiallyExpanded;
  final Duration duration;
  final Color? backgroundColor;
  final Color? titleColor;
  final BorderRadius borderRadius;

  const MahasAccordion({
    super.key,
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
    this.duration = const Duration(milliseconds: 300),
    this.backgroundColor,
    this.titleColor,
    this.borderRadius = MahasBorderRadius.medium,
  });

  @override
  MahasAccordionState createState() => MahasAccordionState();
}

class MahasAccordionState extends State<MahasAccordion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        borderRadius: widget.borderRadius,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: TextStyle(color: widget.titleColor ?? Colors.black),
            ),
            trailing: RotationTransition(
              turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: widget.titleColor ?? Colors.black,
              ),
            ),
            onTap: _toggleExpand,
          ),
          ClipRect(
            child: AnimatedBuilder(
              animation: _controller.view,
              builder: (context, child) {
                return Align(
                  heightFactor: _heightFactor.value,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: widget.content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
