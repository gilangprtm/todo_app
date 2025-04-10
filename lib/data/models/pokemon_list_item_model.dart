class PokemonList {
  final int id;
  final String name;
  final String url;
  final List<PokemonType>? types;

  // Cache for image URLs
  String? _cachedImageUrl;

  PokemonList({
    required this.id,
    required this.name,
    required this.url,
    this.types,
  });

  // Factory constructor to convert from JSON
  factory PokemonList.fromJson(Map<String, dynamic> json) {
    try {
      final int pokemonId = json['id'];

      // Parse types
      List<PokemonType> typesList = [];
      if (json['types'] != null) {
        final types = json['types'] as List;
        for (int i = 0; i < types.length; i++) {
          try {
            final typeData = types[i];
            if (typeData is Map) {
              if (typeData.containsKey('type')) {
                typesList.add(
                    PokemonType.fromJson(typeData as Map<String, dynamic>));
              } else if (typeData.containsKey('name')) {
                // Direct type object
                typesList.add(PokemonType(
                  slot: i + 1,
                  type: TypeInfo(
                    name: typeData['name'],
                    url: typeData['url'] ?? '',
                  ),
                ));
              }
            } else if (typeData is String) {
              // Just type name
              typesList.add(PokemonType(
                slot: i + 1,
                type: TypeInfo(name: typeData, url: ''),
              ));
            }
          } catch (e) {
            // Error parsing specific type
          }
        }
      }

      return PokemonList(
        id: pokemonId,
        name: json['name'] ?? '',
        url: json['url'] ?? 'https://pokeapi.co/api/v2/pokemon/$pokemonId/',
        types: typesList,
      );
    } catch (e) {
      // Error in overall parsing
      return PokemonList(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        url: json['url'] ?? '',
      );
    }
  }

  // Factory constructor for list response
  factory PokemonList.fromListJson(Map<String, dynamic> json) {
    return PokemonList(
      id: int.parse(json['url'].split('/')[6]),
      name: json['name'],
      url: json['url'],
    );
  }

  // Add toJson method to convert Pokemon to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'types': types?.map((type) => type.toJson()).toList(),
    };
  }

  // To get Pokemon image URL based on ID with caching
  String get imageUrl {
    _cachedImageUrl ??=
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
    return _cachedImageUrl!;
  }

  // Get formatted ID (e.g., #001, #025, #150)
  String get formattedId => '#${id.toString().padLeft(3, '0')}';

  // Get capitalized name
  String get capitalizedName =>
      name.substring(0, 1).toUpperCase() + name.substring(1);
}

class PokemonType {
  final int slot;
  final TypeInfo type;

  PokemonType({required this.slot, required this.type});

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    try {
      return PokemonType(
        slot: json['slot'] ?? 1,
        type: TypeInfo.fromJson(json['type']),
      );
    } catch (e) {
      // Error parsing PokemonType
      return PokemonType(
        slot: 1,
        type: TypeInfo(name: '', url: ''),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'slot': slot,
      'type': type.toJson(),
    };
  }
}

class TypeInfo {
  final String name;
  final String url;

  TypeInfo({required this.name, required this.url});

  factory TypeInfo.fromJson(Map<String, dynamic> json) {
    try {
      return TypeInfo(
        name: json['name'] ?? '',
        url: json['url'] ?? '',
      );
    } catch (e) {
      // Error parsing TypeInfo
      return TypeInfo(name: '', url: '');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  // Get formatted stat name (e.g., "HP", "Attack", "Defense")
  String get formattedName {
    switch (name) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'Attack';
      case 'defense':
        return 'Defense';
      case 'special-attack':
        return 'Sp. Atk';
      case 'special-defense':
        return 'Sp. Def';
      case 'speed':
        return 'Speed';
      default:
        return name.substring(0, 1).toUpperCase() + name.substring(1);
    }
  }
}
