class Move {
  final int id;
  final String name;
  final int? accuracy;
  final int? power;
  final int? pp;
  final MoveType? type;
  final MoveDamageClass? damageClass;
  final List<MoveFlavorText>? flavorTextEntries;
  final List<MoveLearnedByPokemon>? learnedByPokemon;
  final int? priority;
  final MoveTarget? target;
  final MoveEffectEntry? effectEntry;

  Move({
    required this.id,
    required this.name,
    this.accuracy,
    this.power,
    this.pp,
    this.type,
    this.damageClass,
    this.flavorTextEntries,
    this.learnedByPokemon,
    this.priority,
    this.target,
    this.effectEntry,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    List<MoveFlavorText>? flavorTextEntries;
    if (json['flavor_text_entries'] != null) {
      flavorTextEntries = (json['flavor_text_entries'] as List)
          .map((entry) => MoveFlavorText.fromJson(entry))
          .toList();
    }

    List<MoveLearnedByPokemon>? learnedByPokemon;
    if (json['learned_by_pokemon'] != null) {
      learnedByPokemon = (json['learned_by_pokemon'] as List)
          .map((pokemon) => MoveLearnedByPokemon.fromJson(pokemon))
          .toList();
    }

    return Move(
      id: json['id'],
      name: json['name'],
      accuracy: json['accuracy'],
      power: json['power'],
      pp: json['pp'],
      type: json['type'] != null ? MoveType.fromJson(json['type']) : null,
      damageClass: json['damage_class'] != null
          ? MoveDamageClass.fromJson(json['damage_class'])
          : null,
      flavorTextEntries: flavorTextEntries,
      learnedByPokemon: learnedByPokemon,
      priority: json['priority'],
      target:
          json['target'] != null ? MoveTarget.fromJson(json['target']) : null,
      effectEntry: json['effect_entries'] != null &&
              (json['effect_entries'] as List).isNotEmpty
          ? MoveEffectEntry.fromJson(json['effect_entries'][0])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (accuracy != null) data['accuracy'] = accuracy;
    if (power != null) data['power'] = power;
    if (pp != null) data['pp'] = pp;
    if (type != null) data['type'] = type!.toJson();
    if (damageClass != null) data['damage_class'] = damageClass!.toJson();
    if (flavorTextEntries != null) {
      data['flavor_text_entries'] =
          flavorTextEntries!.map((item) => item.toJson()).toList();
    }
    if (learnedByPokemon != null) {
      data['learned_by_pokemon'] =
          learnedByPokemon!.map((item) => item.toJson()).toList();
    }
    if (priority != null) data['priority'] = priority;
    if (target != null) data['target'] = target!.toJson();
    if (effectEntry != null) data['effect_entries'] = [effectEntry!.toJson()];
    return data;
  }
}

class MoveType {
  final String name;
  final String url;

  MoveType({
    required this.name,
    required this.url,
  });

  factory MoveType.fromJson(Map<String, dynamic> json) {
    return MoveType(
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

class MoveDamageClass {
  final String name;
  final String url;

  MoveDamageClass({
    required this.name,
    required this.url,
  });

  factory MoveDamageClass.fromJson(Map<String, dynamic> json) {
    return MoveDamageClass(
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

class MoveFlavorText {
  final String flavorText;
  final MoveLanguage language;
  final MoveVersionGroup versionGroup;

  MoveFlavorText({
    required this.flavorText,
    required this.language,
    required this.versionGroup,
  });

  factory MoveFlavorText.fromJson(Map<String, dynamic> json) {
    return MoveFlavorText(
      flavorText: json['flavor_text'],
      language: MoveLanguage.fromJson(json['language']),
      versionGroup: MoveVersionGroup.fromJson(json['version_group']),
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

class MoveLanguage {
  final String name;
  final String url;

  MoveLanguage({
    required this.name,
    required this.url,
  });

  factory MoveLanguage.fromJson(Map<String, dynamic> json) {
    return MoveLanguage(
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

class MoveVersionGroup {
  final String name;
  final String url;

  MoveVersionGroup({
    required this.name,
    required this.url,
  });

  factory MoveVersionGroup.fromJson(Map<String, dynamic> json) {
    return MoveVersionGroup(
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

class MoveLearnedByPokemon {
  final String name;
  final String url;

  MoveLearnedByPokemon({
    required this.name,
    required this.url,
  });

  factory MoveLearnedByPokemon.fromJson(Map<String, dynamic> json) {
    return MoveLearnedByPokemon(
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

class MoveTarget {
  final String name;
  final String url;

  MoveTarget({
    required this.name,
    required this.url,
  });

  factory MoveTarget.fromJson(Map<String, dynamic> json) {
    return MoveTarget(
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

class MoveEffectEntry {
  final String effect;
  final String shortEffect;
  final MoveLanguage language;

  MoveEffectEntry({
    required this.effect,
    required this.shortEffect,
    required this.language,
  });

  factory MoveEffectEntry.fromJson(Map<String, dynamic> json) {
    return MoveEffectEntry(
      effect: json['effect'],
      shortEffect: json['short_effect'],
      language: MoveLanguage.fromJson(json['language']),
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
