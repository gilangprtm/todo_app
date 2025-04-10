import 'api_response_model.dart';

class Location {
  final int id;
  final String name;
  final Region? region;
  final List<LocationName>? names;
  final List<GenerationGameIndex>? gameIndices;
  final List<ResourceListItem>? areas;

  Location({
    required this.id,
    required this.name,
    this.region,
    this.names,
    this.gameIndices,
    this.areas,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    List<LocationName>? names;
    if (json['names'] != null) {
      names = (json['names'] as List)
          .map((name) => LocationName.fromJson(name))
          .toList();
    }

    List<GenerationGameIndex>? gameIndices;
    if (json['game_indices'] != null) {
      gameIndices = (json['game_indices'] as List)
          .map((index) => GenerationGameIndex.fromJson(index))
          .toList();
    }

    List<ResourceListItem>? areas;
    if (json['areas'] != null) {
      areas = (json['areas'] as List)
          .map((area) => ResourceListItem.fromJson(area))
          .toList();
    }

    return Location(
      id: json['id'],
      name: json['name'],
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
      names: names,
      gameIndices: gameIndices,
      areas: areas,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (region != null) data['region'] = region!.toJson();
    if (names != null) {
      data['names'] = names!.map((item) => item.toJson()).toList();
    }
    if (gameIndices != null) {
      data['game_indices'] = gameIndices!.map((item) => item.toJson()).toList();
    }
    if (areas != null) {
      data['areas'] = areas!.map((item) => item.toJson()).toList();
    }
    return data;
  }
}

class Region {
  final String name;
  final String url;

  Region({
    required this.name,
    required this.url,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class LocationName {
  final String name;
  final Language language;

  LocationName({
    required this.name,
    required this.language,
  });

  factory LocationName.fromJson(Map<String, dynamic> json) {
    return LocationName(
      name: json['name'],
      language: Language.fromJson(json['language']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['language'] = language.toJson();
    return data;
  }
}

class Language {
  final String name;
  final String url;

  Language({
    required this.name,
    required this.url,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class GenerationGameIndex {
  final int gameIndex;
  final Generation generation;

  GenerationGameIndex({
    required this.gameIndex,
    required this.generation,
  });

  factory GenerationGameIndex.fromJson(Map<String, dynamic> json) {
    return GenerationGameIndex(
      gameIndex: json['game_index'],
      generation: Generation.fromJson(json['generation']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['game_index'] = gameIndex;
    data['generation'] = generation.toJson();
    return data;
  }
}

class Generation {
  final String name;
  final String url;

  Generation({
    required this.name,
    required this.url,
  });

  factory Generation.fromJson(Map<String, dynamic> json) {
    return Generation(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

// Location Area model (for detailed location area information)
class LocationAreaDetail {
  final int id;
  final String name;
  final int gameIndex;
  final List<EncounterMethodRate>? encounterMethodRates;
  final LocationReference location;
  final List<LocationAreaName>? names;
  final List<PokemonEncounter>? pokemonEncounters;

  LocationAreaDetail({
    required this.id,
    required this.name,
    required this.gameIndex,
    this.encounterMethodRates,
    required this.location,
    this.names,
    this.pokemonEncounters,
  });

  factory LocationAreaDetail.fromJson(Map<String, dynamic> json) {
    List<EncounterMethodRate>? encounterMethodRates;
    if (json['encounter_method_rates'] != null) {
      encounterMethodRates = (json['encounter_method_rates'] as List)
          .map((rate) => EncounterMethodRate.fromJson(rate))
          .toList();
    }

    List<LocationAreaName>? names;
    if (json['names'] != null) {
      names = (json['names'] as List)
          .map((name) => LocationAreaName.fromJson(name))
          .toList();
    }

    List<PokemonEncounter>? pokemonEncounters;
    if (json['pokemon_encounters'] != null) {
      pokemonEncounters = (json['pokemon_encounters'] as List)
          .map((encounter) => PokemonEncounter.fromJson(encounter))
          .toList();
    }

    return LocationAreaDetail(
      id: json['id'],
      name: json['name'],
      gameIndex: json['game_index'],
      encounterMethodRates: encounterMethodRates,
      location: LocationReference.fromJson(json['location']),
      names: names,
      pokemonEncounters: pokemonEncounters,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['game_index'] = gameIndex;
    if (encounterMethodRates != null) {
      data['encounter_method_rates'] =
          encounterMethodRates!.map((item) => item.toJson()).toList();
    }
    data['location'] = location.toJson();
    if (names != null) {
      data['names'] = names!.map((item) => item.toJson()).toList();
    }
    if (pokemonEncounters != null) {
      data['pokemon_encounters'] =
          pokemonEncounters!.map((item) => item.toJson()).toList();
    }
    return data;
  }
}

class EncounterMethodRate {
  final EncounterMethod encounterMethod;
  final List<EncounterVersionDetail> versionDetails;

  EncounterMethodRate({
    required this.encounterMethod,
    required this.versionDetails,
  });

  factory EncounterMethodRate.fromJson(Map<String, dynamic> json) {
    return EncounterMethodRate(
      encounterMethod: EncounterMethod.fromJson(json['encounter_method']),
      versionDetails: (json['version_details'] as List)
          .map((detail) => EncounterVersionDetail.fromJson(detail))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['encounter_method'] = encounterMethod.toJson();
    data['version_details'] =
        versionDetails.map((detail) => detail.toJson()).toList();
    return data;
  }
}

class EncounterMethod {
  final String name;
  final String url;

  EncounterMethod({
    required this.name,
    required this.url,
  });

  factory EncounterMethod.fromJson(Map<String, dynamic> json) {
    return EncounterMethod(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class EncounterVersionDetail {
  final int rate;
  final Version version;

  EncounterVersionDetail({
    required this.rate,
    required this.version,
  });

  factory EncounterVersionDetail.fromJson(Map<String, dynamic> json) {
    return EncounterVersionDetail(
      rate: json['rate'],
      version: Version.fromJson(json['version']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rate'] = rate;
    data['version'] = version.toJson();
    return data;
  }
}

class Version {
  final String name;
  final String url;

  Version({
    required this.name,
    required this.url,
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class LocationAreaName {
  final String name;
  final Language language;

  LocationAreaName({
    required this.name,
    required this.language,
  });

  factory LocationAreaName.fromJson(Map<String, dynamic> json) {
    return LocationAreaName(
      name: json['name'],
      language: Language.fromJson(json['language']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['language'] = language.toJson();
    return data;
  }
}

class PokemonEncounter {
  final PokemonSpecies pokemon;
  final List<VersionEncounterDetail> versionDetails;

  PokemonEncounter({
    required this.pokemon,
    required this.versionDetails,
  });

  factory PokemonEncounter.fromJson(Map<String, dynamic> json) {
    return PokemonEncounter(
      pokemon: PokemonSpecies.fromJson(json['pokemon']),
      versionDetails: (json['version_details'] as List)
          .map((detail) => VersionEncounterDetail.fromJson(detail))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pokemon'] = pokemon.toJson();
    data['version_details'] =
        versionDetails.map((detail) => detail.toJson()).toList();
    return data;
  }
}

class PokemonSpecies {
  final String name;
  final String url;

  PokemonSpecies({
    required this.name,
    required this.url,
  });

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    return PokemonSpecies(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class VersionEncounterDetail {
  final Version version;
  final int maxChance;
  final List<Encounter> encounterDetails;

  VersionEncounterDetail({
    required this.version,
    required this.maxChance,
    required this.encounterDetails,
  });

  factory VersionEncounterDetail.fromJson(Map<String, dynamic> json) {
    return VersionEncounterDetail(
      version: Version.fromJson(json['version']),
      maxChance: json['max_chance'],
      encounterDetails: (json['encounter_details'] as List)
          .map((detail) => Encounter.fromJson(detail))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version.toJson();
    data['max_chance'] = maxChance;
    data['encounter_details'] =
        encounterDetails.map((detail) => detail.toJson()).toList();
    return data;
  }
}

class Encounter {
  final int minLevel;
  final int maxLevel;
  final List<ConditionValue>? conditionValues;
  final int chance;
  final EncounterMethod method;

  Encounter({
    required this.minLevel,
    required this.maxLevel,
    this.conditionValues,
    required this.chance,
    required this.method,
  });

  factory Encounter.fromJson(Map<String, dynamic> json) {
    List<ConditionValue>? conditionValues;
    if (json['condition_values'] != null) {
      conditionValues = (json['condition_values'] as List)
          .map((value) => ConditionValue.fromJson(value))
          .toList();
    }

    return Encounter(
      minLevel: json['min_level'],
      maxLevel: json['max_level'],
      conditionValues: conditionValues,
      chance: json['chance'],
      method: EncounterMethod.fromJson(json['method']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min_level'] = minLevel;
    data['max_level'] = maxLevel;
    if (conditionValues != null) {
      data['condition_values'] =
          conditionValues!.map((value) => value.toJson()).toList();
    }
    data['chance'] = chance;
    data['method'] = method.toJson();
    return data;
  }
}

class ConditionValue {
  final String name;
  final String url;

  ConditionValue({
    required this.name,
    required this.url,
  });

  factory ConditionValue.fromJson(Map<String, dynamic> json) {
    return ConditionValue(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

// Tambahkan class baru untuk location reference
class LocationReference {
  final String name;
  final String url;

  LocationReference({
    required this.name,
    required this.url,
  });

  factory LocationReference.fromJson(Map<String, dynamic> json) {
    return LocationReference(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}
