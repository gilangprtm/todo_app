import 'package:flutter/material.dart';

import '../mahas_type.dart';

class MahasAvatar extends StatelessWidget {
  final String? avatarUrl;
  final IconData? iconData;
  final MahasAvatarSize size;
  final BorderRadius borderRadius;
  final MahasAvatarType type;
  final Color? backgroundColor;
  final Color? iconColor;

  const MahasAvatar({
    super.key,
    this.avatarUrl,
    this.iconData,
    this.size = MahasAvatarSize.medium,
    this.borderRadius = MahasBorderRadius.circle,
    this.type = MahasAvatarType.image,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    double avatarSize;
    switch (size) {
      case MahasAvatarSize.small:
        avatarSize = 30.0;
        break;
      case MahasAvatarSize.medium:
        avatarSize = 60.0;
        break;
      case MahasAvatarSize.large:
        avatarSize = 90.0;
        break;
    }

    Widget avatarContent;
    switch (type) {
      case MahasAvatarType.image:
        avatarContent = _buildImageAvatar();
        break;
      case MahasAvatarType.icon:
        avatarContent = _buildIconAvatar();
        break;
      case MahasAvatarType.outline:
        avatarContent = _buildOutlineAvatar();
        break;
    }

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: avatarContent,
      ),
    );
  }

  Widget _buildImageAvatar() {
    return avatarUrl != null
        ? Image.network(
            avatarUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholder();
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildPlaceholder();
            },
          )
        : _buildPlaceholder();
  }

  Widget _buildIconAvatar() {
    return Icon(
      iconData,
      size: 24.0,
      color: iconColor,
    );
  }

  Widget _buildOutlineAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: iconColor ?? Colors.black, width: 2.0),
      ),
      child: Center(
        child: Icon(
          iconData,
          size: 24.0,
          color: iconColor ?? Colors.black,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.person,
          size: 24.0,
          color: Colors.grey,
        ),
      ),
    );
  }
}
