# Lapisan Service

## Pengenalan

Lapisan Service berperan sebagai penghubung antara Repository (yang bertanggung jawab untuk mendapatkan data dari sumber eksternal) dan lapisan UI (melalui StateNotifier). Lapisan ini menambahkan abstraksi untuk caching, transformasi data, dan logika bisnis.

## Struktur Service

```dart
class BaseService {
  // Metode caching
  Future<T> cachedOperationAsync<T>({
    required String cacheKey,
    required int ttlMinutes,
    required Future<T> Function() fetchFunction,
    required String operationName,
    String? tag,
    bool forceRefresh = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    // Implementasi caching
  }
}

class PokemonService extends BaseService {
  final PokemonRepository _repository = PokemonRepository();

  // Metode-metode spesifik service
}
```

## Tanggung Jawab

Lapisan Service memiliki tanggung jawab sebagai berikut:

1. **Caching**: Menyimpan dan mengelola data dalam cache untuk mengurangi panggilan jaringan.
2. **Transformasi Data**: Mengkonversi data dari format Repository ke format yang lebih cocok untuk UI.
3. **Logika Bisnis**: Menerapkan aturan dan logika bisnis pada data.
4. **Pelacakan Status**: Menangani logging dan pelacakan status operasi.

## BaseService

`BaseService` adalah kelas dasar yang menyediakan fungsionalitas umum untuk semua layanan.

```dart
class BaseService {
  // Metode untuk operasi yang di-cache
  Future<T> cachedOperationAsync<T>({
    required String cacheKey,
    required int ttlMinutes,
    required Future<T> Function() fetchFunction,
    required String operationName,
    String? tag,
    bool forceRefresh = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final cacheService = CacheService();

    if (!forceRefresh) {
      final cachedData = cacheService.get(key: cacheKey);
      if (cachedData != null) {
        loginfo('$operationName: Cache hit for $cacheKey');

        if (fromJson != null && cachedData is Map<String, dynamic>) {
          return fromJson(cachedData);
        }

        return cachedData as T;
      }
    } else {
      loginfo('$operationName: Force refresh for $cacheKey');
    }

    // Cache miss or force refresh
    try {
      final data = await fetchFunction();

      // Store in cache
      await cacheService.put(
        key: cacheKey,
        data: data,
        ttl: Duration(minutes: ttlMinutes),
        tag: tag,
      );

      return data;
    } catch (e, stackTrace) {
      logError('$operationName: Error fetching data', e, stackTrace);
      rethrow;
    }
  }
}
```

## Contoh Service

### PokemonService

```dart
class PokemonService extends BaseService {
  final PokemonRepository _repository = PokemonRepository();

  // Mendapatkan daftar Pokemon
  Future<List<PokemonModel>> getPokemonList({
    int limit = 20,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'pokemon_list_${limit}_${offset}';

    return cachedOperationAsync(
      cacheKey: cacheKey,
      ttlMinutes: 60 * 24, // 1 day
      forceRefresh: forceRefresh,
      operationName: 'PokemonService.getPokemonList',
      fetchFunction: () async {
        return await _repository.getPokemonList(limit: limit, offset: offset);
      },
      tag: 'PokemonService',
    );
  }

  // Mendapatkan detail Pokemon
  Future<PokemonDetailModel> getPokemonDetail(
    int id, {
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'pokemon_detail_$id';

    return cachedOperationAsync(
      cacheKey: cacheKey,
      ttlMinutes: 60 * 24 * 7, // 7 days
      forceRefresh: forceRefresh,
      operationName: 'PokemonService.getPokemonDetail',
      fetchFunction: () async {
        return await _repository.getPokemonDetail(id);
      },
      tag: 'PokemonService',
    );
  }

  // Pencarian Pokemon
  Future<List<PokemonModel>> searchPokemon(
    String query, {
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'pokemon_search_${query.toLowerCase()}';

    return cachedOperationAsync(
      cacheKey: cacheKey,
      ttlMinutes: 60 * 24, // 1 day
      forceRefresh: forceRefresh,
      operationName: 'PokemonService.searchPokemon',
      fetchFunction: () async {
        final allPokemon = await getPokemonList(limit: 1000, forceRefresh: forceRefresh);

        if (query.isEmpty) return allPokemon;

        final lowerQuery = query.toLowerCase();
        return allPokemon.where((pokemon) {
          return pokemon.name.toLowerCase().contains(lowerQuery) ||
                 pokemon.id.toString() == query;
        }).toList();
      },
      tag: 'PokemonService',
    );
  }

  // Membersihkan cache
  Future<void> clearCache() async {
    final cacheService = CacheService();
    await cacheService.clearCacheByTag('PokemonService');
  }

  // Mendapatkan statistik cache
  Map<String, dynamic> getCacheStats() {
    final cacheService = CacheService();
    return cacheService.getCacheStats();
  }
}
```

### AbilityService

```dart
class AbilityService extends BaseService {
  final AbilityRepository _repository = AbilityRepository();

  // Mendapatkan daftar kemampuan
  Future<List<AbilityModel>> getAbilities({
    int limit = 20,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'abilities_list_${limit}_${offset}';

    return cachedOperationAsync(
      cacheKey: cacheKey,
      ttlMinutes: 60 * 24, // 1 day
      forceRefresh: forceRefresh,
      operationName: 'AbilityService.getAbilities',
      fetchFunction: () async {
        return await _repository.getAbilities(limit: limit, offset: offset);
      },
      tag: 'AbilityService',
    );
  }

  // Mendapatkan detail kemampuan
  Future<AbilityDetailModel> getAbilityDetail(
    int id, {
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'ability_detail_$id';

    return cachedOperationAsync(
      cacheKey: cacheKey,
      ttlMinutes: 60 * 24 * 7, // 7 days
      forceRefresh: forceRefresh,
      operationName: 'AbilityService.getAbilityDetail',
      fetchFunction: () async {
        return await _repository.getAbilityDetail(id);
      },
      tag: 'AbilityService',
    );
  }

  // Membersihkan cache
  Future<void> clearCache() async {
    final cacheService = CacheService();
    await cacheService.clearCacheByTag('AbilityService');
  }
}
```

## Integrasi dengan Provider

Service diregistrasi sebagai provider untuk digunakan di seluruh aplikasi:

```dart
// di lib/core/di/service_providers.dart
final pokemonServiceProvider = Provider<PokemonService>((ref) {
  return PokemonService();
});

final abilityServiceProvider = Provider<AbilityService>((ref) {
  return AbilityService();
});

final moveServiceProvider = Provider<MoveService>((ref) {
  return MoveService();
});

// dan seterusnya untuk service lainnya
```

## Penggunaan dalam StateNotifier

Service digunakan dalam StateNotifier untuk mendapatkan data:

```dart
class PokemonListNotifier extends BaseStateNotifier<PokemonListState> {
  final PokemonService _pokemonService;

  PokemonListNotifier(
    super.initialState,
    super.ref,
    this._pokemonService,
  );

  @override
  void onInit() {
    super.onInit();
    loadPokemonList();
  }

  Future<void> loadPokemonList({bool refresh = false}) async {
    await runAsync('loadPokemonList', () async {
      if (refresh) {
        state = state.copyWith(
          pokemonList: const [],
          currentPage: 1,
          hasMoreData: true,
        );
      }

      if (!state.hasMoreData) return;

      final offset = (state.currentPage - 1) * 20;
      final pokemonList = await _pokemonService.getPokemonList(
        limit: 20,
        offset: offset,
        forceRefresh: refresh,
      );

      state = state.copyWith(
        pokemonList: [...state.pokemonList, ...pokemonList],
        currentPage: state.currentPage + 1,
        hasMoreData: pokemonList.length >= 20,
      );
    });
  }

  Future<void> searchPokemon(String query) async {
    await runAsync('searchPokemon', () async {
      state = state.copyWith(searchQuery: query);

      if (query.isEmpty) {
        state = state.copyWith(
          searchResults: const [],
          isSearching: false,
        );
        return;
      }

      state = state.copyWith(isSearching: true);

      final results = await _pokemonService.searchPokemon(query);

      state = state.copyWith(
        searchResults: results,
        isSearching: false,
      );
    });
  }

  Future<void> clearCache() async {
    await _pokemonService.clearCache();
    await loadPokemonList(refresh: true);
  }
}
```

## Pola Desain Service

### 1. Enkapsulasi Repository

Service mengenkapsulasi Repository dan menambahkan kemampuan caching:

```dart
class TypeService extends BaseService {
  final TypeRepository _repository = TypeRepository();

  // Service methods that use the repository
}
```

### 2. Method Signature yang Konsisten

Semua metode yang mengambil data dari API memiliki parameter `forceRefresh` opsional:

```dart
Future<T> getSomeData({bool forceRefresh = false}) async {
  // Implementation
}
```

### 3. Pengelompokan Cache dengan Tag

Semua entri cache untuk service tertentu dikelompokkan dengan tag untuk memudahkan pembersihan:

```dart
return cachedOperationAsync(
  // Other parameters
  tag: 'ServiceName',
);
```

### 4. Metode Pembersihan Cache

Setiap service menyediakan metode untuk membersihkan cache-nya:

```dart
Future<void> clearCache() async {
  final cacheService = CacheService();
  await cacheService.clearCacheByTag('ServiceName');
}
```

### 5. Transformasi Data

Service dapat melakukan transformasi data sebelum mengembalikannya:

```dart
Future<List<SimplifiedModel>> getSimplifiedData({bool forceRefresh = false}) async {
  final fullData = await getFullData(forceRefresh: forceRefresh);
  return fullData.map((item) => SimplifiedModel.fromFullModel(item)).toList();
}
```

## Praktik Terbaik

1. **Isolasi Logika Bisnis**: Tempatkan logika bisnis di service, bukan di repository atau notifier.

2. **Granularitas Cache**: Gunakan kunci cache yang spesifik untuk memaksimalkan hit rate.

3. **TTL yang Sesuai**: Tetapkan TTL (Time To Live) yang sesuai dengan tingkat perubahan data.

4. **Error Handling**: Tangani kesalahan di service dan laporkan dengan jelas.

5. **Logging**: Tambahkan logging untuk operasi penting dan error.

6. **Unit Testing**: Buat unit test untuk semua service dengan mock repository.

## Unit Testing

```dart
void main() {
  late PokemonService pokemonService;
  late MockPokemonRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonRepository();
    // Use a mock cache service for testing
    CacheService.instance = MockCacheService();
    pokemonService = PokemonService();
    // Replace the repository in the service with the mock
    pokemonService.repository = mockRepository;
  });

  test('getPokemonList should return cached data if available', () async {
    // Setup
    final mockData = [PokemonModel(id: 1, name: 'Bulbasaur')];
    MockCacheService.mockGet('pokemon_list_20_0', mockData);

    // Act
    final result = await pokemonService.getPokemonList();

    // Assert
    expect(result, equals(mockData));
    verifyNever(mockRepository.getPokemonList(any, any));
  });

  test('getPokemonList should fetch from repository if cache miss', () async {
    // Setup
    final mockData = [PokemonModel(id: 1, name: 'Bulbasaur')];
    MockCacheService.mockGet('pokemon_list_20_0', null); // Cache miss
    when(mockRepository.getPokemonList(any, any)).thenAnswer((_) async => mockData);

    // Act
    final result = await pokemonService.getPokemonList();

    // Assert
    expect(result, equals(mockData));
    verify(mockRepository.getPokemonList(20, 0)).called(1);
    verify(MockCacheService.mockPut('pokemon_list_20_0', mockData, any, 'PokemonService')).called(1);
  });

  test('getPokemonList should fetch from repository if forceRefresh is true', () async {
    // Setup
    final mockData = [PokemonModel(id: 1, name: 'Bulbasaur')];
    final cachedData = [PokemonModel(id: 2, name: 'Ivysaur')];
    MockCacheService.mockGet('pokemon_list_20_0', cachedData);
    when(mockRepository.getPokemonList(any, any)).thenAnswer((_) async => mockData);

    // Act
    final result = await pokemonService.getPokemonList(forceRefresh: true);

    // Assert
    expect(result, equals(mockData)); // Should get fresh data, not cached
    verify(mockRepository.getPokemonList(20, 0)).called(1);
    verify(MockCacheService.mockPut('pokemon_list_20_0', mockData, any, 'PokemonService')).called(1);
  });
}
```
