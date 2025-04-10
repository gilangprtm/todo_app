// Notifier Template for Code Generator
const String notifierTemplate = '''
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fokedex/core/base/base_state_notifier.dart';
import '{{stateImportPath}}';
import '{{serviceImportPath}}';

/// Notifier for managing {{featureName}} state.
class {{NotifierClassName}} extends BaseStateNotifier<{{StateClassName}}> {
  final {{ServiceClassName}} _{{serviceName}};
  
  /// Creates a new instance of [{{NotifierClassName}}].
  {{NotifierClassName}}(
    super.initialState,
    super.ref,
    this._{{serviceName}},
  );
  
  @override
  void onInit() {
    super.onInit();
    {{#hasInitMethod}}
    {{initMethodName}}();
    {{/hasInitMethod}}
  }
  
  {{#methods}}
  /// {{description}}
  Future<void> {{name}}({{#params}}{{type}} {{name}}{{^isLast}}, {{/isLast}}{{/params}}) async {
    await runAsync('{{name}}', () async {
      {{body}}
    });
  }
  
  {{/methods}}
  
  {{#hasRefreshMethod}}
  /// Refreshes the data by forcing a cache refresh.
  Future<void> refresh() async {
    await {{refreshMethodName}}(refresh: true);
  }
  {{/hasRefreshMethod}}
  
  {{#hasClearCacheMethod}}
  /// Clears the cache and reloads the data.
  Future<void> clearCache() async {
    await _{{serviceName}}.clearCache();
    await {{refreshMethodTarget}}(refresh: true);
  }
  {{/hasClearCacheMethod}}
}
''';
