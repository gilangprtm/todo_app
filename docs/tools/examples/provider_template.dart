// Provider Template for Code Generator
const String providerTemplate = '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '{{stateImportPath}}';
import '{{notifierImportPath}}';
{{#serviceImports}}
import '{{path}}';
{{/serviceImports}}

/// Provider for {{featureName}} feature.
final {{providerName}} = StateNotifierProvider<{{NotifierClassName}}, {{StateClassName}}>((ref) {
  {{#dependencies}}
  final {{name}} = ref.watch({{providerName}});
  {{/dependencies}}
  
  return {{NotifierClassName}}(
    const {{StateClassName}}(),
    ref,
    {{#dependencies}}
    {{name}},
    {{/dependencies}}
  );
});
''';
