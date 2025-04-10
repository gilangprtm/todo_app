// State Template for Code Generator
const String stateTemplate = '''
import 'package:flutter/foundation.dart';
import 'package:fokedex/core/base/base_state.dart';
import '{{modelImportPath}}';

/// State for {{featureName}} feature.
///
/// Contains all data needed for the UI representation.
class {{StateClassName}} extends BaseState {
  {{#properties}}
  /// {{description}}
  final {{type}} {{name}};
  {{/properties}}
  
  /// Creates a new instance of [{{StateClassName}}].
  const {{StateClassName}}({
    {{#properties}}
    this.{{name}}{{#hasDefaultValue}} = {{defaultValue}}{{/hasDefaultValue}},
    {{/properties}}
    super.isLoading = false,
    super.error,
    super.stackTrace,
  });
  
  @override
  {{StateClassName}} copyWith({
    {{#properties}}
    {{type}}? {{name}},
    {{/properties}}
    bool? isLoading,
    String? error,
    StackTrace? stackTrace,
    bool clearError = false,
  }) {
    return {{StateClassName}}(
      {{#properties}}
      {{name}}: {{name}} ?? this.{{name}},
      {{/properties}}
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is {{StateClassName}} &&
      other.isLoading == isLoading &&
      other.error == error &&
      other.stackTrace == stackTrace &&
      {{#properties}}
      other.{{name}} == {{name}}{{^isLast}} &&{{/isLast}}
      {{/properties}};
  }
  
  @override
  int get hashCode => Object.hash(
    isLoading,
    error,
    stackTrace,
    {{#properties}}
    {{name}}{{^isLast}},{{/isLast}}
    {{/properties}}
  );
}
''';
