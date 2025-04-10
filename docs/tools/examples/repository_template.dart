// Repository Template for Code Generator
const String repositoryTemplate = '''
import 'package:dio/dio.dart';
import 'package:fokedex/core/network/base_repository.dart';
import 'package:fokedex/data/models/{{modelImportPath}}';

/// Repository for {{featureName}} API operations.
class {{RepositoryClassName}} extends BaseRepository {
  {{#endpoints}}
  /// {{description}}
  Future<{{returnType}}> {{methodName}}({{#params}}{{type}} {{name}}{{^isLast}}, {{/isLast}}{{/params}}) async {
    {{#isListMethod}}
    final response = await dio.{{httpMethod}}('{{path}}');
    return (response.data as List)
        .map((json) => {{modelName}}.fromJson(json))
        .toList();
    {{/isListMethod}}
    {{#isDetailMethod}}
    final response = await dio.{{httpMethod}}('{{path}}');
    return {{modelName}}.fromJson(response.data);
    {{/isDetailMethod}}
    {{#isPostMethod}}
    final response = await dio.{{httpMethod}}(
      '{{path}}',
      data: {{#hasModel}}model.toJson(){{/hasModel}}{{^hasModel}}data{{/hasModel}},
    );
    return {{modelName}}.fromJson(response.data);
    {{/isPostMethod}}
    {{#isDeleteMethod}}
    await dio.{{httpMethod}}('{{path}}');
    return true;
    {{/isDeleteMethod}}
  }
  
  {{/endpoints}}
}
''';
