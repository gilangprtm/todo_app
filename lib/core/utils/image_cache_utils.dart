import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Utility class for image caching and loading optimizations
class ImageCacheUtils {
  // Singleton instance for custom cache manager
  static final BaseCacheManager _customCacheManager = CacheManager(
    Config(
      'pokemon_images_cache',
      stalePeriod: const Duration(days: 7), // Keep images valid for 7 days
      maxNrOfCacheObjects: 300, // Maximum number of cached objects
      repo: JsonCacheInfoRepository(databaseName: 'pokemon_cache_db'),
      fileService: HttpFileService(),
    ),
  );

  /// Get the custom cache manager optimized for the app
  static BaseCacheManager get customCacheManager => _customCacheManager;

  /// Clear the image cache (useful for debugging or low storage situations)
  static Future<void> clearCache() async {
    await _customCacheManager.emptyCache();
  }

  /// Check if a specific URL is cached
  static Future<bool> isImageCached(String url) async {
    final fileInfo = await _customCacheManager.getFileFromCache(url);
    return fileInfo != null;
  }

  /// Helper method to build a Pokemon image with consistent styling
  static Widget buildPokemonImage({
    required String imageUrl,
    required double height,
    required double width,
    Color? progressColor,
    BoxFit fit = BoxFit.contain,
    Widget Function(BuildContext, String, dynamic)? errorWidget,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      cacheManager: _customCacheManager,
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: width / 2,
          height: height / 2,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor ?? Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      errorWidget: errorWidget ??
          (context, url, error) => const Icon(
                Icons.catching_pokemon,
                size: 40,
              ),
    );
  }
}
