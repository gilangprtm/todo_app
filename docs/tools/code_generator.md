# Code Generator

## Pengenalan

Code Generator adalah alat otomatis yang dibuat untuk mempercepat pengembangan aplikasi dengan mengotomatisasi pembuatan kode boilerplate untuk berbagai komponen seperti model, service, state, notifier, dan provider. Alat ini membantu menjaga konsistensi dan mengurangi kesalahan manual dalam implementasi Riverpod.

## Tujuan

1. **Mengurangi kode boilerplate**: Mengurangi penulisan kode berulang secara manual.
2. **Memastikan konsistensi**: Menjaga pola dan konvensi yang konsisten di seluruh kode.
3. **Mempercepat pengembangan**: Mempersingkat waktu untuk membuat komponen baru.
4. **Mengurangi kesalahan**: Menghindari kesalahan pengetikan dan kesalahan implementasi umum.

## Arsitektur Generator

Generator dirancang dengan pendekatan modular, memungkinkan pengembang untuk membuat berbagai jenis komponen aplikasi.

```
lib/
├── core/
│   └── generator/
│       ├── generator.dart
│       ├── model_generator.dart
│       ├── repository_generator.dart
│       ├── service_generator.dart
│       ├── state_generator.dart
│       ├── notifier_generator.dart
│       ├── provider_generator.dart
│       └── templates/
│           ├── model_template.dart
│           ├── repository_template.dart
│           └── ...
```

## Cara Penggunaan

### CLI Interface

Generator dapat diakses melalui CLI dengan perintah:

```bash
flutter pub run generator:create <type> --name=<name> [--options]
```

Contoh:

```bash
flutter pub run generator:create model --name=product --fields="id:int,name:String,price:double,description:String?"
```

### Tipe Generator

1. **Model Generator**
2. **Repository Generator**
3. **Service Generator**
4. **State Generator**
5. **Notifier Generator**
6. **Provider Generator**
7. **Complete Feature Generator**

## Fitur Generator

### 1. Model Generator

Membuat model data dengan konversi JSON, konstruktor, dan metode utilitas.

**Penggunaan:**

```bash
flutter pub run generator:create model --name=product --fields="id:int,name:String,price:double,description:String?"
```

**Output:**

```dart
// lib/data/models/product_model.dart
class ProductModel {
  final int id;
  final String name;
  final double price;
  final String? description;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
    );
  }
}
```

### 2. Repository Generator

Membuat repository untuk akses API dengan metode HTTP standar.

**Penggunaan:**

```bash
flutter pub run generator:create repository --name=product --model=ProductModel --endpoints="list:GET:/products,detail:GET:/products/{id}"
```

**Output:**

```dart
// lib/data/datasource/network/repository/product_repository.dart
class ProductRepository extends BaseRepository {
  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get('/products');
    return (response.data as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final response = await dio.get('/products/$id');
    return ProductModel.fromJson(response.data);
  }
}
```

### 3. Service Generator

Membuat service dengan integrasi caching.

**Penggunaan:**

```bash
flutter pub run generator:create service --name=product --model=ProductModel --repository=ProductRepository
```

**Output:**

```dart
// lib/data/datasource/network/service/product_service.dart
class ProductService extends BaseService {
  final ProductRepository _repository = ProductRepository();

  Future<List<ProductModel>> getProducts({bool forceRefresh = false}) {
    final cacheKey = 'products_list';

    return cachedOperationAsync(
      cacheKey: cacheKey,
      ttlMinutes: 60 * 24, // 1 day
      forceRefresh: forceRefresh,
      operationName: 'ProductService.getProducts',
      fetchFunction: () async {
        return await _repository.getProducts();
      },
      tag: 'ProductService',
    );
  }

  Future<ProductModel> getProductById(int id, {bool forceRefresh = false}) {
    final cacheKey = 'product_$id';

    return cachedOperationAsync(
      cacheKey: cacheKey,
      ttlMinutes: 60 * 24, // 1 day
      forceRefresh: forceRefresh,
      operationName: 'ProductService.getProductById',
      fetchFunction: () async {
        return await _repository.getProductById(id);
      },
      tag: 'ProductService',
    );
  }

  Future<void> clearCache() async {
    final cacheService = CacheService();
    await cacheService.clearCacheByTag('ProductService');
  }
}
```

### 4. State Generator

Membuat kelas state untuk Riverpod dengan BaseState.

**Penggunaan:**

```bash
flutter pub run generator:create state --name=product_list --properties="products:List<ProductModel>,currentPage:int=1,hasMore:bool=true"
```

**Output:**

```dart
// lib/presentation/providers/product/product_list/product_list_state.dart
class ProductListState extends BaseState {
  final List<ProductModel> products;
  final int currentPage;
  final bool hasMore;

  const ProductListState({
    this.products = const [],
    this.currentPage = 1,
    this.hasMore = true,
    super.isLoading = false,
    super.error,
    super.stackTrace,
  });

  @override
  ProductListState copyWith({
    List<ProductModel>? products,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    String? error,
    StackTrace? stackTrace,
    bool clearError = false,
  }) {
    return ProductListState(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
    );
  }
}
```

### 5. Notifier Generator

Membuat notifier untuk manajemen state.

**Penggunaan:**

```bash
flutter pub run generator:create notifier --name=product_list --state=ProductListState --service=ProductService --methods="loadProducts,refreshProducts"
```

**Output:**

```dart
// lib/presentation/providers/product/product_list/product_list_notifier.dart
class ProductListNotifier extends BaseStateNotifier<ProductListState> {
  final ProductService _productService;

  ProductListNotifier(super.initialState, super.ref, this._productService);

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts({bool refresh = false}) async {
    await runAsync('loadProducts', () async {
      if (refresh) {
        state = state.copyWith(
          products: [],
          currentPage: 1,
          hasMore: true,
          clearError: true,
        );
      }

      if (!state.hasMore) return;

      final offset = (state.currentPage - 1) * 20;
      final products = await _productService.getProducts(
        forceRefresh: refresh,
      );

      state = state.copyWith(
        products: [...state.products, ...products],
        currentPage: state.currentPage + 1,
        hasMore: products.isNotEmpty && products.length >= 20,
      );
    });
  }

  Future<void> refreshProducts() async {
    await loadProducts(refresh: true);
  }
}
```

### 6. Provider Generator

Membuat provider untuk Riverpod.

**Penggunaan:**

```bash
flutter pub run generator:create provider --name=product_list --notifier=ProductListNotifier --state=ProductListState --dependencies="productService:ProductService"
```

**Output:**

```dart
// lib/presentation/providers/product/product_list/product_list_provider.dart
final productListProvider = StateNotifierProvider<ProductListNotifier, ProductListState>((ref) {
  final productService = ref.watch(productServiceProvider);
  return ProductListNotifier(
    const ProductListState(),
    ref,
    productService,
  );
});

// Update file: lib/core/di/service_providers.dart
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});
```

### 7. Complete Feature Generator

Membuat semua komponen untuk fitur baru sekaligus.

**Penggunaan:**

```bash
flutter pub run generator:create feature --name=product --model="id:int,name:String,price:double,description:String?" --endpoints="list:GET:/products,detail:GET:/products/{id}" --states="list:products:List<ProductModel>,detail:product:ProductModel"
```

**Output:**
Semua file yang termasuk dalam fitur lengkap (model, repository, service, state, notifier, provider, dll.).

## Struktur Komponen yang Dihasilkan

```
lib/
├── data/
│   ├── models/
│   │   └── product_model.dart
│   └── datasource/
│       └── network/
│           ├── repository/
│           │   └── product_repository.dart
│           └── service/
│               └── product_service.dart
├── presentation/
│   ├── providers/
│   │   └── product/
│   │       ├── product_list/
│   │       │   ├── product_list_state.dart
│   │       │   ├── product_list_notifier.dart
│   │       │   └── product_list_provider.dart
│   │       └── product_detail/
│   │           ├── product_detail_state.dart
│   │           ├── product_detail_notifier.dart
│   │           └── product_detail_provider.dart
│   └── pages/
│       └── product/
│           ├── product_list/
│           │   └── product_list_page.dart
│           └── product_detail/
│               └── product_detail_page.dart
└── core/
    └── di/
        └── service_providers.dart (diperbarui)
```

## Customization

Generator mendukung penyesuaian melalui file konfigurasi:

```yaml
# generator_config.yaml
output_paths:
  models: lib/data/models
  repositories: lib/data/datasource/network/repository
  services: lib/data/datasource/network/service
  states: lib/presentation/providers/{feature}/{subfeature}
  notifiers: lib/presentation/providers/{feature}/{subfeature}
  providers: lib/presentation/providers/{feature}/{subfeature}

templates:
  model: lib/core/generator/templates/model_template.dart
  repository: lib/core/generator/templates/repository_template.dart
  service: lib/core/generator/templates/service_template.dart
  state: lib/core/generator/templates/state_template.dart
  notifier: lib/core/generator/templates/notifier_template.dart
  provider: lib/core/generator/templates/provider_template.dart

default_values:
  cache_ttl_minutes: 1440 # 24 hours
  pagination_size: 20
  imports:
    - "package:flutter/material.dart"
    - "package:flutter_riverpod/flutter_riverpod.dart"
```

## Kustomisasi Template

Pengguna dapat menyesuaikan template generator dengan membuat template kustom:

```dart
// lib/core/generator/templates/custom_model_template.dart
const String modelTemplate = '''
import 'package:flutter/foundation.dart';

// Custom model template with additional features
class {{ModelName}} {
  {{#fields}}
  final {{type}} {{name}};
  {{/fields}}

  const {{ModelName}}({
    {{#fields}}
    {{#required}}required {{/required}}this.{{name}},
    {{/fields}}
  });

  factory {{ModelName}}.fromJson(Map<String, dynamic> json) {
    return {{ModelName}}(
      {{#fields}}
      {{name}}: {{fromJsonConverter}},
      {{/fields}}
    );
  }

  Map<String, dynamic> toJson() {
    return {
      {{#fields}}
      '{{name}}': {{name}},
      {{/fields}}
    };
  }

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
```

## Integrasi dengan Tools Lain

Generator dapat diintegrasikan dengan:

1. **Build Runners**: Untuk pembuatan kode otomatis saat pengembangan.
2. **CI/CD Pipeline**: Untuk validasi kode yang dihasilkan.
3. **IDE Extensions**: Untuk dukungan langsung di editor.

## Praktik Terbaik

1. **Gunakan untuk Komponen yang Konsisten**: Generator paling berguna untuk komponen dengan pola yang dapat diprediksi.

2. **Validasi Kode yang Dihasilkan**: Selalu periksa dan validasi kode yang dihasilkan untuk memastikan kualitas.

3. **Perbarui Template jika Diperlukan**: Sesuaikan template jika ada perubahan pada pola arsitektur.

4. **Dokumentasikan Generator**: Buat dokumentasi tentang cara menggunakan dan memperluas generator.

5. **Uji Generator**: Buat unit test untuk memverifikasi bahwa generator berfungsi dengan benar.

## Implementasi

Berikut adalah contoh implementasi dasar untuk generator model:

```dart
// lib/core/generator/model_generator.dart
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'templates/model_template.dart';

class ModelGenerator {
  final String name;
  final Map<String, String> fields;
  final String outputDir;

  ModelGenerator({
    required this.name,
    required this.fields,
    this.outputDir = 'lib/data/models',
  });

  Future<void> generate() async {
    final fileName = '${name.snakeCase}_model.dart';
    final filePath = path.join(outputDir, fileName);

    // Create directory if it doesn't exist
    final directory = Directory(outputDir);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Generate field definitions
    final fieldDefinitions = fields.entries.map((entry) {
      final fieldName = entry.key;
      final fieldType = entry.value;
      final isRequired = !fieldType.endsWith('?');
      final type = isRequired ? fieldType : fieldType.substring(0, fieldType.length - 1);

      return {
        'name': fieldName,
        'type': type,
        'required': isRequired,
        'fromJsonConverter': _getFromJsonConverter(fieldName, type),
        'isLast': false,
      };
    }).toList();

    if (fieldDefinitions.isNotEmpty) {
      fieldDefinitions.last['isLast'] = true;
    }

    // Replace template placeholders
    var modelCode = modelTemplate
      .replaceAll('{{ModelName}}', '${name.pascalCase}Model')
      .replaceAll('{{#fields}}', '')
      .replaceAll('{{/fields}}', '');

    // Replace field placeholders
    for (final field in fieldDefinitions) {
      modelCode = _replacePlaceholders(modelCode, field);
    }

    // Write to file
    final file = File(filePath);
    await file.writeAsString(modelCode);

    print('Generated model: $filePath');
  }

  String _getFromJsonConverter(String fieldName, String type) {
    switch (type) {
      case 'int':
        return "json['$fieldName'] as int";
      case 'String':
        return "json['$fieldName'] as String";
      case 'double':
        return "(json['$fieldName'] as num).toDouble()";
      case 'bool':
        return "json['$fieldName'] as bool";
      default:
        if (type.startsWith('List<')) {
          final itemType = type.substring(5, type.length - 1);
          return "(json['$fieldName'] as List).map((e) => ${_getItemConverter(itemType, 'e')}).toList()";
        }
        return "$type.fromJson(json['$fieldName'] as Map<String, dynamic>)";
    }
  }

  String _getItemConverter(String type, String variable) {
    switch (type) {
      case 'int':
        return "$variable as int";
      case 'String':
        return "$variable as String";
      case 'double':
        return "($variable as num).toDouble()";
      case 'bool':
        return "$variable as bool";
      default:
        return "$type.fromJson($variable as Map<String, dynamic>)";
    }
  }

  String _replacePlaceholders(String template, Map<String, dynamic> field) {
    var result = template;

    for (final entry in field.entries) {
      final placeholder = '{{${entry.key}}}';
      final value = entry.value.toString();

      result = result.replaceAll(placeholder, value);

      // Handle conditional sections
      if (entry.value is bool) {
        final startTag = '{{#${entry.key}}}';
        final endTag = '{{/${entry.key}}}';

        if (entry.value as bool) {
          // Keep content but remove tags
          result = result.replaceAll(startTag, '').replaceAll(endTag, '');
        } else {
          // Remove content and tags
          final regex = RegExp('$startTag(.*?)$endTag', dotAll: true);
          result = result.replaceAll(regex, '');
        }
      }
    }

    return result;
  }
}
```

## Contoh CLI

```dart
// bin/generator.dart
import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import '../lib/core/generator/model_generator.dart';
import '../lib/core/generator/repository_generator.dart';
import '../lib/core/generator/service_generator.dart';
import '../lib/core/generator/state_generator.dart';
import '../lib/core/generator/notifier_generator.dart';
import '../lib/core/generator/provider_generator.dart';
import '../lib/core/generator/feature_generator.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('model')
    ..addCommand('repository')
    ..addCommand('service')
    ..addCommand('state')
    ..addCommand('notifier')
    ..addCommand('provider')
    ..addCommand('feature');

  try {
    final argResults = parser.parse(arguments);

    if (argResults.command == null) {
      _printUsage(parser);
      exit(1);
    }

    final command = argResults.command!.name;
    final commandArgs = argResults.command!.arguments;

    // Parse common options
    final name = _parseOption(commandArgs, '--name=');
    if (name == null) {
      print('Error: --name option is required');
      exit(1);
    }

    switch (command) {
      case 'model':
        final fields = _parseMapOption(commandArgs, '--fields=');
        if (fields.isEmpty) {
          print('Error: --fields option is required for model generator');
          exit(1);
        }

        final generator = ModelGenerator(name: name, fields: fields);
        await generator.generate();
        break;

      case 'repository':
        final model = _parseOption(commandArgs, '--model=');
        if (model == null) {
          print('Error: --model option is required for repository generator');
          exit(1);
        }

        final endpoints = _parseEndpointsOption(commandArgs, '--endpoints=');
        if (endpoints.isEmpty) {
          print('Error: --endpoints option is required for repository generator');
          exit(1);
        }

        final generator = RepositoryGenerator(
          name: name,
          model: model,
          endpoints: endpoints,
        );
        await generator.generate();
        break;

      // Implement other generators...

      case 'feature':
        final model = _parseMapOption(commandArgs, '--model=');
        if (model.isEmpty) {
          print('Error: --model option is required for feature generator');
          exit(1);
        }

        final endpoints = _parseEndpointsOption(commandArgs, '--endpoints=');
        if (endpoints.isEmpty) {
          print('Error: --endpoints option is required for feature generator');
          exit(1);
        }

        final states = _parseStatesOption(commandArgs, '--states=');
        if (states.isEmpty) {
          print('Error: --states option is required for feature generator');
          exit(1);
        }

        final generator = FeatureGenerator(
          name: name,
          model: model,
          endpoints: endpoints,
          states: states,
        );
        await generator.generate();
        break;

      default:
        print('Unknown command: $command');
        _printUsage(parser);
        exit(1);
    }

    print('Generation completed successfully!');
  } catch (e) {
    print('Error: $e');
    _printUsage(parser);
    exit(1);
  }
}

String? _parseOption(List<String> args, String prefix) {
  for (final arg in args) {
    if (arg.startsWith(prefix)) {
      return arg.substring(prefix.length);
    }
  }
  return null;
}

Map<String, String> _parseMapOption(List<String> args, String prefix) {
  final option = _parseOption(args, prefix);
  if (option == null) {
    return {};
  }

  final result = <String, String>{};
  final pairs = option.split(',');

  for (final pair in pairs) {
    final parts = pair.split(':');
    if (parts.length == 2) {
      result[parts[0]] = parts[1];
    }
  }

  return result;
}

List<Map<String, String>> _parseEndpointsOption(List<String> args, String prefix) {
  final option = _parseOption(args, prefix);
  if (option == null) {
    return [];
  }

  final result = <Map<String, String>>[];
  final endpoints = option.split(',');

  for (final endpoint in endpoints) {
    final parts = endpoint.split(':');
    if (parts.length == 3) {
      result.add({
        'name': parts[0],
        'method': parts[1],
        'path': parts[2],
      });
    }
  }

  return result;
}

List<Map<String, String>> _parseStatesOption(List<String> args, String prefix) {
  final option = _parseOption(args, prefix);
  if (option == null) {
    return [];
  }

  final result = <Map<String, String>>[];
  final states = option.split(',');

  for (final state in states) {
    final parts = state.split(':');
    if (parts.length >= 3) {
      result.add({
        'name': parts[0],
        'property': parts[1],
        'type': parts[2],
      });
    }
  }

  return result;
}

void _printUsage(ArgParser parser) {
  print('Usage:');
  print('flutter pub run generator:create <command> [options]');
  print('');
  print('Commands:');
  print('  model       Generate a model class');
  print('  repository  Generate a repository class');
  print('  service     Generate a service class');
  print('  state       Generate a state class');
  print('  notifier    Generate a notifier class');
  print('  provider    Generate a provider');
  print('  feature     Generate a complete feature');
  print('');
  print('Examples:');
  print('  flutter pub run generator:create model --name=product --fields="id:int,name:String,price:double"');
  print('  flutter pub run generator:create feature --name=product --model="id:int,name:String" --endpoints="list:GET:/products,detail:GET:/products/{id}" --states="list:products:List<ProductModel>,detail:product:ProductModel"');
}
```
