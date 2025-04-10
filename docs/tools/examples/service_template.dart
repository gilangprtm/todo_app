// Service Template for Code Generator
const String serviceTemplate = '''
import 'package:fokedex/core/services/base_service.dart';
import 'package:fokedex/data/datasource/network/repositories/{{repositoryImportPath}}';
import 'package:fokedex/data/models/{{modelImportPath}}';
import 'package:fokedex/core/services/cache_service.dart';

/// Service for handling {{featureName}} data operations.
class {{ServiceClassName}} extends BaseService {
  final {{RepositoryClassName}} _repository = {{RepositoryClassName}}();
  
  {{#methods}}
  /// {{description}}
  Future<{{returnType}}> {{name}}({{#params}}{{type}} {{name}}{{^isLast}}, {{/isLast}}{{/params}}{{#hasParams}}{{#hasOptionalParams}}, {{/hasOptionalParams}}{{/hasParams}}{{#hasOptionalParams}}{bool forceRefresh = false}{{/hasOptionalParams}}) {
    final cacheKey = '{{cacheKeyTemplate}}';
    
    return cachedOperationAsync(
      cacheKey: cacheKey,
      ttlMinutes: {{ttlMinutes}},
      forceRefresh: forceRefresh,
      operationName: '{{ServiceClassName}}.{{name}}',
      fetchFunction: () async {
        return await _repository.{{repositoryMethodName}}({{#params}}{{name}}{{^isLast}}, {{/isLast}}{{/params}});
      },
      {{#hasFromJson}}
      fromJson: (json) => {{returnType}}.fromJson(json),
      {{/hasFromJson}}
      tag: '{{ServiceClassName}}',
    );
  }
  
  {{/methods}}
  
  /// Clears the cache for this service.
  Future<void> clearCache() async {
    final cacheService = CacheService();
    await cacheService.clearCacheByTag('{{ServiceClassName}}');
  }
  
  /// Gets cache statistics for this service.
  Map<String, dynamic> getCacheStats() {
    final cacheService = CacheService();
    final stats = cacheService.getCacheStats();
    
    // Filter for just this service's stats
    final allTags = stats['tagDistribution'] as Map<String, dynamic>;
    
    return {
      'totalEntries': stats['totalEntries'],
      'serviceEntries': allTags['{{ServiceClassName}}'] ?? 0,
      'utilizationPercentage': stats['utilizationPercentage'],
    };
  }
}
''';
