class Pokemon {
  final int id;
  final String name;
  final String url;
  final int? height;
  final int? weight;
  final List<PokemonType>? types;
  final List<PokemonAbility>? abilities;
  final List<PokemonStat>? stats;
  final List<PokemonMove>? moves;
  final PokemonSprites? sprites;
  final String? species;

  // Cache for image URLs
  String? _cachedImageUrl;
  String? _cachedOfficialArtwork;
  String? _cachedHomeImageUrl;
  String? _cachedDreamWorldImageUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.url,
    this.height,
    this.weight,
    this.types,
    this.abilities,
    this.stats,
    this.moves,
    this.sprites,
    this.species,
  });

  // Factory constructor to convert from JSON
  factory Pokemon.fromJson(Map<String, dynamic> json) {
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

      // Parse abilities
      List<PokemonAbility> abilitiesList = [];
      if (json['abilities'] != null) {
        try {
          final abilities = json['abilities'] as List;
          for (int i = 0; i < abilities.length; i++) {
            abilitiesList.add(PokemonAbility.fromJson(abilities[i]));
          }
        } catch (e) {
          // Error parsing abilities
        }
      }

      // Parse stats
      List<PokemonStat> statsList = [];
      if (json['stats'] != null) {
        try {
          final stats = json['stats'] as List;
          for (int i = 0; i < stats.length; i++) {
            statsList.add(PokemonStat.fromJson(stats[i]));
          }
        } catch (e) {
          // Error parsing stats
        }
      }

      // Parse moves
      List<PokemonMove> movesList = [];
      if (json['moves'] != null) {
        try {
          final moves = json['moves'] as List;
          for (int i = 0; i < moves.length; i++) {
            movesList.add(PokemonMove.fromJson(moves[i]));
          }
        } catch (e) {
          // Error parsing moves
        }
      }

      // Parse sprites
      PokemonSprites? sprites;
      if (json['sprites'] != null) {
        try {
          sprites = PokemonSprites.fromJson(json['sprites']);
        } catch (e) {
          // Error parsing sprites
        }
      }

      // Parse species
      String speciesUrl = '';
      if (json['species'] != null && json['species'] is Map) {
        speciesUrl = json['species']['url'] ?? '';
      }

      return Pokemon(
        id: pokemonId,
        name: json['name'] ?? '',
        url: json['url'] ?? 'https://pokeapi.co/api/v2/pokemon/$pokemonId/',
        height: json['height'] != null
            ? (json['height'] is int
                ? json['height']
                : int.parse('${json['height']}'))
            : 0,
        weight: json['weight'] != null
            ? (json['weight'] is int
                ? json['weight']
                : int.parse('${json['weight']}'))
            : 0,
        types: typesList,
        abilities: abilitiesList,
        stats: statsList,
        moves: movesList,
        sprites: sprites,
        species: speciesUrl,
      );
    } catch (e) {
      // Error in overall parsing
      return Pokemon(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        url: json['url'] ?? '',
        height: 0,
        weight: 0,
      );
    }
  }

  // Factory constructor for list response
  factory Pokemon.fromListJson(Map<String, dynamic> json) {
    return Pokemon(
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
      'height': height,
      'weight': weight,
      'types': types?.map((type) => type.toJson()).toList(),
      'abilities': abilities?.map((ability) => ability.toJson()).toList(),
      'stats': stats?.map((stat) => stat.toJson()).toList(),
      'moves': moves?.map((move) => move.toJson()).toList(),
      'sprites': sprites?.toJson(),
      'species': species,
    };
  }

  // To get Pokemon image URL based on ID with caching
  String get imageUrl {
    _cachedImageUrl ??=
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
    return _cachedImageUrl!;
  }

  // Higher quality alternatives with caching
  String get dreamWorldImageUrl {
    if (sprites?.other?.dreamWorld?.frontDefault != null &&
        sprites!.other!.dreamWorld!.frontDefault!.isNotEmpty) {
      _cachedDreamWorldImageUrl ??= sprites!.other!.dreamWorld!.frontDefault!;
      return _cachedDreamWorldImageUrl!;
    }
    return imageUrl; // Fallback to default
  }

  // Get the Home artwork if available
  String get homeImageUrl {
    if (sprites?.other?.home?.frontDefault != null &&
        sprites!.other!.home!.frontDefault!.isNotEmpty) {
      _cachedHomeImageUrl ??= sprites!.other!.home!.frontDefault!;
      return _cachedHomeImageUrl!;
    }
    return imageUrl; // Fallback to default
  }

  // Get official artwork if available
  String get officialArtworkImageUrl {
    if (sprites?.other?.officialArtwork?.frontDefault != null &&
        sprites!.other!.officialArtwork!.frontDefault!.isNotEmpty) {
      _cachedOfficialArtwork ??= sprites!.other!.officialArtwork!.frontDefault!;
      return _cachedOfficialArtwork!;
    }
    return imageUrl; // Fallback to default
  }

  // Get formatted ID (e.g., #001, #025, #150)
  String get formattedId => '#${id.toString().padLeft(3, '0')}';

  // Get formatted height in meters
  String get formattedHeight =>
      height != null ? '${(height! / 10).toStringAsFixed(1)} m' : 'Unknown';

  // Get formatted weight in kg
  String get formattedWeight =>
      weight != null ? '${(weight! / 10).toStringAsFixed(1)} kg' : 'Unknown';

  // Get capitalized name
  String get capitalizedName =>
      name.substring(0, 1).toUpperCase() + name.substring(1);

  // Static method to get the official artwork URL for a Pokemon by ID
  static String getOfficialArtworkUrl(String id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }
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

class PokemonAbility {
  final bool isHidden;
  final int slot;
  final AbilityInfo ability;

  PokemonAbility({
    required this.isHidden,
    required this.slot,
    required this.ability,
  });

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    try {
      return PokemonAbility(
        isHidden: json['is_hidden'] ?? false,
        slot: json['slot'] ?? 1,
        ability: AbilityInfo.fromJson(json['ability']),
      );
    } catch (e) {
      // Error parsing PokemonAbility
      return PokemonAbility(
        isHidden: false,
        slot: 1,
        ability: AbilityInfo(name: '', url: ''),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'is_hidden': isHidden,
      'slot': slot,
      'ability': ability.toJson(),
    };
  }
}

class AbilityInfo {
  final String name;
  final String url;

  AbilityInfo({required this.name, required this.url});

  factory AbilityInfo.fromJson(Map<String, dynamic> json) {
    try {
      return AbilityInfo(
        name: json['name'] ?? '',
        url: json['url'] ?? '',
      );
    } catch (e) {
      // Error parsing AbilityInfo
      return AbilityInfo(name: '', url: '');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class PokemonStat {
  final int baseStat;
  final int effort;
  final StatInfo stat;

  PokemonStat({
    required this.baseStat,
    required this.effort,
    required this.stat,
  });

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    try {
      return PokemonStat(
        baseStat: json['base_stat'] ?? 0,
        effort: json['effort'] ?? 0,
        stat: StatInfo.fromJson(json['stat']),
      );
    } catch (e) {
      // Error parsing PokemonStat
      return PokemonStat(
        baseStat: 0,
        effort: 0,
        stat: StatInfo(name: '', url: ''),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'base_stat': baseStat,
      'effort': effort,
      'stat': stat.toJson(),
    };
  }
}

class StatInfo {
  final String name;
  final String url;

  StatInfo({required this.name, required this.url});

  factory StatInfo.fromJson(Map<String, dynamic> json) {
    try {
      return StatInfo(
        name: json['name'] ?? '',
        url: json['url'] ?? '',
      );
    } catch (e) {
      // Error parsing StatInfo
      return StatInfo(name: '', url: '');
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

class PokemonMove {
  final MoveInfo move;

  PokemonMove({required this.move});

  factory PokemonMove.fromJson(Map<String, dynamic> json) {
    try {
      return PokemonMove(
        move: MoveInfo.fromJson(json['move']),
      );
    } catch (e) {
      // Error parsing PokemonMove
      return PokemonMove(
        move: MoveInfo(name: '', url: ''),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'move': move.toJson(),
    };
  }
}

class MoveInfo {
  final String name;
  final String url;

  MoveInfo({required this.name, required this.url});

  factory MoveInfo.fromJson(Map<String, dynamic> json) {
    try {
      return MoveInfo(
        name: json['name'] ?? '',
        url: json['url'] ?? '',
      );
    } catch (e) {
      // Error parsing MoveInfo
      return MoveInfo(name: '', url: '');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class PokemonSprites {
  final String frontDefault;
  final String? backDefault;
  final Other? other;

  PokemonSprites({
    required this.frontDefault,
    this.backDefault,
    this.other,
  });

  factory PokemonSprites.fromJson(Map<String, dynamic> json) {
    try {
      return PokemonSprites(
        frontDefault: json['front_default'] ?? '',
        backDefault: json['back_default'],
        other: json['other'] != null ? Other.fromJson(json['other']) : null,
      );
    } catch (e) {
      // Error parsing PokemonSprites
      return PokemonSprites(
        frontDefault: '',
        backDefault: null,
        other: null,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'front_default': frontDefault,
      'back_default': backDefault,
      'other': other?.toJson(),
    };
  }
}

class Other {
  final DreamWorld? dreamWorld;
  final Home? home;
  final OfficialArtwork? officialArtwork;

  Other({
    this.dreamWorld,
    this.home,
    this.officialArtwork,
  });

  factory Other.fromJson(Map<String, dynamic> json) {
    try {
      return Other(
        dreamWorld: json['dream_world'] != null
            ? DreamWorld.fromJson(json['dream_world'])
            : null,
        home: json['home'] != null ? Home.fromJson(json['home']) : null,
        officialArtwork: json['official-artwork'] != null
            ? OfficialArtwork.fromJson(json['official-artwork'])
            : null,
      );
    } catch (e) {
      // Error parsing Other
      return Other();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'dream_world': dreamWorld?.toJson(),
      'home': home?.toJson(),
      'official-artwork': officialArtwork?.toJson(),
    };
  }
}

class DreamWorld {
  final String? frontDefault;

  DreamWorld({this.frontDefault});

  factory DreamWorld.fromJson(Map<String, dynamic> json) {
    try {
      return DreamWorld(
        frontDefault: json['front_default'],
      );
    } catch (e) {
      // Error parsing DreamWorld
      return DreamWorld();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'front_default': frontDefault,
    };
  }
}

class Home {
  final String? frontDefault;

  Home({this.frontDefault});

  factory Home.fromJson(Map<String, dynamic> json) {
    try {
      return Home(
        frontDefault: json['front_default'],
      );
    } catch (e) {
      // Error parsing Home
      return Home();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'front_default': frontDefault,
    };
  }
}

class OfficialArtwork {
  final String? frontDefault;

  OfficialArtwork({this.frontDefault});

  factory OfficialArtwork.fromJson(Map<String, dynamic> json) {
    try {
      return OfficialArtwork(
        frontDefault: json['front_default'],
      );
    } catch (e) {
      // Error parsing OfficialArtwork
      return OfficialArtwork();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'front_default': frontDefault,
    };
  }
}

class PokemonReference {
  final String name;
  final String url;

  PokemonReference({
    required this.name,
    required this.url,
  });

  factory PokemonReference.fromJson(Map<String, dynamic> json) {
    return PokemonReference(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  String get id {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    return pathSegments[pathSegments.length - 2];
  }

  String get formattedName {
    return name
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String get imageUrl {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }
}
