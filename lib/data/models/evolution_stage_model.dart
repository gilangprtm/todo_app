class EvolutionStage {
  final String name;
  final String id;
  final String imageUrl;
  final List<String> evolutionDetails;

  EvolutionStage({
    required this.name,
    required this.id,
    required this.imageUrl,
    this.evolutionDetails = const [],
  });

  factory EvolutionStage.fromMap(Map<String, dynamic> map) {
    return EvolutionStage(
      name: map['name'] as String,
      id: map['id'] as String,
      imageUrl: map['imageUrl'] as String,
      evolutionDetails: map['evolutionDetails'] != null
          ? List<String>.from(map['evolutionDetails'])
          : [],
    );
  }
}
