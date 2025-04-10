import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../mahas_type.dart';

class MahasImage extends StatelessWidget {
  final String imageUrl;
  final String? localPath;
  final String? svgPath;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const MahasImage({
    super.key,
    required this.imageUrl,
    this.localPath,
    this.svgPath,
    this.width = 100.0,
    this.height = 100.0,
    this.fit = BoxFit.cover,
    this.borderRadius = MahasBorderRadius.medium,
  });

  @override
  Widget build(BuildContext context) {
    if (svgPath != null) {
      return _buildSvgImage();
    } else if (localPath != null) {
      return _buildLocalImage();
    } else {
      return _buildNetworkImage();
    }
  }

  Widget _buildNetworkImage() {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.error),
        ),
        fadeInDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildLocalImage() {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        localPath!,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }

  Widget _buildSvgImage() {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SvgPicture.asset(
        svgPath!,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
