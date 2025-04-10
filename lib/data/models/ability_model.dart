class Ability {
  final int id;
  final String name;
  final bool isMainSeries;
  final Generation? generation;
  final List<AbilityName>? names;
  final List<AbilityEffectEntry>? effectEntries;
  final List<AbilityFlavorText>? flavorTextEntries;
  final List<AbilityPokemon>? pokemon;

  Ability({
    required this.id,
    required this.name,
    required this.isMainSeries,
    this.generation,
    this.names,
    this.effectEntries,
    this.flavorTextEntries,
    this.pokemon,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    List<AbilityName>? names;
    if (json['names'] != null) {
      names = (json['names'] as List)
          .map((name) => AbilityName.fromJson(name))
          .toList();
    }

    List<AbilityEffectEntry>? effectEntries;
    if (json['effect_entries'] != null) {
      effectEntries = (json['effect_entries'] as List)
          .map((entry) => AbilityEffectEntry.fromJson(entry))
          .toList();
    }

    List<AbilityFlavorText>? flavorTextEntries;
    if (json['flavor_text_entries'] != null) {
      flavorTextEntries = (json['flavor_text_entries'] as List)
          .map((entry) => AbilityFlavorText.fromJson(entry))
          .toList();
    }

    List<AbilityPokemon>? pokemon;
    if (json['pokemon'] != null) {
      pokemon = (json['pokemon'] as List)
          .map((p) => AbilityPokemon.fromJson(p))
          .toList();
    }

    return Ability(
      id: json['id'],
      name: json['name'],
      isMainSeries: json['is_main_series'] ?? false,
      generation: json['generation'] != null
          ? Generation.fromJson(json['generation'])
          : null,
      names: names,
      effectEntries: effectEntries,
      flavorTextEntries: flavorTextEntries,
      pokemon: pokemon,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_main_series'] = isMainSeries;
    if (generation != null) data['generation'] = generation!.toJson();
    if (names != null) {
      data['names'] = names!.map((item) => item.toJson()).toList();
    }
    if (effectEntries != null) {
      data['effect_entries'] =
          effectEntries!.map((item) => item.toJson()).toList();
    }
    if (flavorTextEntries != null) {
      data['flavor_text_entries'] =
          flavorTextEntries!.map((item) => item.toJson()).toList();
    }
    if (pokemon != null) {
      data['pokemon'] = pokemon!.map((item) => item.toJson()).toList();
    }
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

class AbilityName {
  final String name;
  final Language language;

  AbilityName({
    required this.name,
    required this.language,
  });

  factory AbilityName.fromJson(Map<String, dynamic> json) {
    return AbilityName(
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

class AbilityEffectEntry {
  final String effect;
  final String shortEffect;
  final Language language;

  AbilityEffectEntry({
    required this.effect,
    required this.shortEffect,
    required this.language,
  });

  factory AbilityEffectEntry.fromJson(Map<String, dynamic> json) {
    return AbilityEffectEntry(
      effect: json['effect'],
      shortEffect: json['short_effect'],
      language: Language.fromJson(json['language']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['effect'] = effect;
    data['short_effect'] = shortEffect;
    data['language'] = language.toJson();
    return data;
  }
}

class AbilityFlavorText {
  final String flavorText;
  final Language language;
  final VersionGroup versionGroup;

  AbilityFlavorText({
    required this.flavorText,
    required this.language,
    required this.versionGroup,
  });

  factory AbilityFlavorText.fromJson(Map<String, dynamic> json) {
    return AbilityFlavorText(
      flavorText: json['flavor_text'],
      language: Language.fromJson(json['language']),
      versionGroup: VersionGroup.fromJson(json['version_group']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flavor_text'] = flavorText;
    data['language'] = language.toJson();
    data['version_group'] = versionGroup.toJson();
    return data;
  }
}

class VersionGroup {
  final String name;
  final String url;

  VersionGroup({
    required this.name,
    required this.url,
  });

  factory VersionGroup.fromJson(Map<String, dynamic> json) {
    return VersionGroup(
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

class AbilityPokemon {
  final bool isHidden;
  final int slot;
  final PokemonSpecies pokemon;

  AbilityPokemon({
    required this.isHidden,
    required this.slot,
    required this.pokemon,
  });

  factory AbilityPokemon.fromJson(Map<String, dynamic> json) {
    return AbilityPokemon(
      isHidden: json['is_hidden'],
      slot: json['slot'],
      pokemon: PokemonSpecies.fromJson(json['pokemon']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_hidden'] = isHidden;
    data['slot'] = slot;
    data['pokemon'] = pokemon.toJson();
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
