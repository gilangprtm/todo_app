// Model Template for Code Generator
const String modelTemplate = '''
import 'package:meta/meta.dart';

/// {{ModelName}} represents the data model for {{modelNameLower}}.
///
/// This model is used for API responses and database operations.
class {{ModelName}} {
  {{#fields}}
  /// {{description}}
  final {{type}} {{name}};
  {{/fields}}
  
  /// Creates a new instance of [{{ModelName}}].
  const {{ModelName}}({
    {{#fields}}
    {{#required}}required {{/required}}this.{{name}},
    {{/fields}}
  });
  
  /// Creates a [{{ModelName}}] from JSON data.
  factory {{ModelName}}.fromJson(Map<String, dynamic> json) {
    return {{ModelName}}(
      {{#fields}}
      {{name}}: {{fromJsonConverter}},
      {{/fields}}
    );
  }
  
  /// Converts this [{{ModelName}}] to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      {{#fields}}
      '{{name}}': {{name}},
      {{/fields}}
    };
  }
  
  /// Creates a copy of this [{{ModelName}}] but with the given fields replaced.
  {{ModelName}} copyWith({
    {{#fields}}
    {{type}}? {{name}},
    {{/fields}}
  }) {
    return {{ModelName}}(
      {{#fields}}
      {{name}}: {{name}} ?? this.{{name}},
      {{/fields}}
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is {{ModelName}} &&
      {{#fields}}
      other.{{name}} == {{name}}{{^isLast}} &&{{/isLast}}
      {{/fields}};
  }
  
  @override
  int get hashCode => Object.hash(
    {{#fields}}
    {{name}}{{^isLast}},{{/isLast}}
    {{/fields}}
  );
}
''';
