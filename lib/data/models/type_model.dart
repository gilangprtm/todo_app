import 'ability_model.dart';
import 'api_response_model.dart';

class TypeDetail {
  final int id;
  final String name;
  final TypeDamageRelations damageRelations;
  final List<TypeRelationsPast>? pastDamageRelations;
  final List<GenerationGameIndex>? gameIndices;
  final Generation? generation;
  final MoveDamageClass? moveDamageClass;
  final List<TypeName>? names;
  final List<TypePokemon>? pokemon;
  final List<ResourceListItem>? moves;

  TypeDetail({
    required this.id,
    required this.name,
    required this.damageRelations,
    this.pastDamageRelations,
    this.gameIndices,
    this.generation,
    this.moveDamageClass,
    this.names,
    this.pokemon,
    this.moves,
  });

  factory TypeDetail.fromJson(Map<String, dynamic> json) {
    List<TypeRelationsPast>? pastDamageRelations;
    if (json['past_damage_relations'] != null) {
      pastDamageRelations = (json['past_damage_relations'] as List)
          .map((item) => TypeRelationsPast.fromJson(item))
          .toList();
    }

    List<GenerationGameIndex>? gameIndices;
    if (json['game_indices'] != null) {
      gameIndices = (json['game_indices'] as List)
          .map((index) => GenerationGameIndex.fromJson(index))
          .toList();
    }

    List<TypeName>? names;
    if (json['names'] != null) {
      names = (json['names'] as List)
          .map((name) => TypeName.fromJson(name))
          .toList();
    }

    List<TypePokemon>? pokemon;
    if (json['pokemon'] != null) {
      pokemon = (json['pokemon'] as List)
          .map((p) => TypePokemon.fromJson(p))
          .toList();
    }

    List<ResourceListItem>? moves;
    if (json['moves'] != null) {
      moves = (json['moves'] as List)
          .map((m) => ResourceListItem.fromJson(m))
          .toList();
    }

    return TypeDetail(
      id: json['id'],
      name: json['name'],
      damageRelations: TypeDamageRelations.fromJson(json['damage_relations']),
      pastDamageRelations: pastDamageRelations,
      gameIndices: gameIndices,
      generation: json['generation'] != null
          ? Generation.fromJson(json['generation'])
          : null,
      moveDamageClass: json['move_damage_class'] != null
          ? MoveDamageClass.fromJson(json['move_damage_class'])
          : null,
      names: names,
      pokemon: pokemon,
      moves: moves,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['damage_relations'] = damageRelations.toJson();
    if (pastDamageRelations != null) {
      data['past_damage_relations'] =
          pastDamageRelations!.map((item) => item.toJson()).toList();
    }
    if (gameIndices != null) {
      data['game_indices'] = gameIndices!.map((item) => item.toJson()).toList();
    }
    if (generation != null) data['generation'] = generation!.toJson();
    if (moveDamageClass != null) {
      data['move_damage_class'] = moveDamageClass!.toJson();
    }
    if (names != null) {
      data['names'] = names!.map((item) => item.toJson()).toList();
    }
    if (pokemon != null) {
      data['pokemon'] = pokemon!.map((item) => item.toJson()).toList();
    }
    if (moves != null) {
      data['moves'] = moves!.map((item) => item.toJson()).toList();
    }
    return data;
  }
}

class TypeDamageRelations {
  final List<TypeInfo> noDamageTo;
  final List<TypeInfo> halfDamageTo;
  final List<TypeInfo> doubleDamageTo;
  final List<TypeInfo> noDamageFrom;
  final List<TypeInfo> halfDamageFrom;
  final List<TypeInfo> doubleDamageFrom;

  TypeDamageRelations({
    required this.noDamageTo,
    required this.halfDamageTo,
    required this.doubleDamageTo,
    required this.noDamageFrom,
    required this.halfDamageFrom,
    required this.doubleDamageFrom,
  });

  factory TypeDamageRelations.fromJson(Map<String, dynamic> json) {
    return TypeDamageRelations(
      noDamageTo: (json['no_damage_to'] as List)
          .map((type) => TypeInfo.fromJson(type))
          .toList(),
      halfDamageTo: (json['half_damage_to'] as List)
          .map((type) => TypeInfo.fromJson(type))
          .toList(),
      doubleDamageTo: (json['double_damage_to'] as List)
          .map((type) => TypeInfo.fromJson(type))
          .toList(),
      noDamageFrom: (json['no_damage_from'] as List)
          .map((type) => TypeInfo.fromJson(type))
          .toList(),
      halfDamageFrom: (json['half_damage_from'] as List)
          .map((type) => TypeInfo.fromJson(type))
          .toList(),
      doubleDamageFrom: (json['double_damage_from'] as List)
          .map((type) => TypeInfo.fromJson(type))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no_damage_to'] = noDamageTo.map((type) => type.toJson()).toList();
    data['half_damage_to'] = halfDamageTo.map((type) => type.toJson()).toList();
    data['double_damage_to'] =
        doubleDamageTo.map((type) => type.toJson()).toList();
    data['no_damage_from'] = noDamageFrom.map((type) => type.toJson()).toList();
    data['half_damage_from'] =
        halfDamageFrom.map((type) => type.toJson()).toList();
    data['double_damage_from'] =
        doubleDamageFrom.map((type) => type.toJson()).toList();
    return data;
  }
}

class TypeRelationsPast {
  final Generation generation;
  final TypeDamageRelations damageRelations;

  TypeRelationsPast({
    required this.generation,
    required this.damageRelations,
  });

  factory TypeRelationsPast.fromJson(Map<String, dynamic> json) {
    return TypeRelationsPast(
      generation: Generation.fromJson(json['generation']),
      damageRelations: TypeDamageRelations.fromJson(json['damage_relations']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['generation'] = generation.toJson();
    data['damage_relations'] = damageRelations.toJson();
    return data;
  }
}

class TypeName {
  final String name;
  final Language language;

  TypeName({
    required this.name,
    required this.language,
  });

  factory TypeName.fromJson(Map<String, dynamic> json) {
    return TypeName(
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

class TypePokemon {
  final int slot;
  final PokemonInfo pokemon;

  TypePokemon({
    required this.slot,
    required this.pokemon,
  });

  factory TypePokemon.fromJson(Map<String, dynamic> json) {
    return TypePokemon(
      slot: json['slot'],
      pokemon: PokemonInfo.fromJson(json['pokemon']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slot'] = slot;
    data['pokemon'] = pokemon.toJson();
    return data;
  }
}

class PokemonInfo {
  final String name;
  final String url;

  PokemonInfo({
    required this.name,
    required this.url,
  });

  factory PokemonInfo.fromJson(Map<String, dynamic> json) {
    return PokemonInfo(
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

class TypeInfo {
  final String name;
  final String url;

  TypeInfo({
    required this.name,
    required this.url,
  });

  factory TypeInfo.fromJson(Map<String, dynamic> json) {
    return TypeInfo(
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
