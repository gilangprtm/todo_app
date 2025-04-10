import 'package:flutter/material.dart';

import '../../theme/app_typografi.dart';
import '../mahas_type.dart';

class MahasBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius borderRadius;
  final double? fontSize;

  const MahasBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = MahasBorderRadius.small,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Text(
        text,
        style: AppTypography.caption.copyWith(
          color: textColor ?? Colors.white,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class MahasBadgeWith extends StatelessWidget {
  final int? badgeCount;
  final String? text;
  final BorderRadius borderRadius;
  final BadgePosition badgePosition;
  final bool showBadgeText;
  final Widget? child;
  final Color? badgeColor;

  const MahasBadgeWith({
    super.key,
    this.badgeCount,
    this.text,
    this.borderRadius = MahasBorderRadius.circle,
    this.badgePosition = BadgePosition.topRight,
    this.showBadgeText = true,
    this.child,
    this.badgeColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child ?? Container(),
        _buildBadge(),
      ],
    );
  }

  Widget _buildBadge() {
    double badgeOffset =
        showBadgeText ? 0.0 : 2.0; // Adjust offset based on showBadgeText
    return Positioned(
      top: _getBadgePosition().top != null
          ? _getBadgePosition().top! + badgeOffset
          : null,
      right: _getBadgePosition().right != null
          ? _getBadgePosition().right! + badgeOffset
          : null,
      bottom: _getBadgePosition().bottom != null
          ? _getBadgePosition().bottom! + badgeOffset
          : null,
      left: _getBadgePosition().left != null
          ? _getBadgePosition().left! + badgeOffset
          : null,
      child: showBadgeText
          ? MahasBadge(
              text: text ?? (badgeCount! > 99 ? '99+' : badgeCount.toString()),
              backgroundColor: badgeColor,
              borderRadius: borderRadius,
            )
          : Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
    );
  }

  _BadgePosition _getBadgePosition() {
    switch (badgePosition) {
      case BadgePosition.topLeft:
        return _BadgePosition(top: 0, left: 0);
      case BadgePosition.topRight:
        return _BadgePosition(top: 0, right: 0);
      case BadgePosition.bottomLeft:
        return _BadgePosition(bottom: 0, left: 0);
      case BadgePosition.bottomRight:
        return _BadgePosition(bottom: 0, right: 0);
      case BadgePosition.center:
        return _BadgePosition();
    }
  }
}

class _BadgePosition {
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;

  _BadgePosition({this.top, this.right, this.bottom, this.left});
}
