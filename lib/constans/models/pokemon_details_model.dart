class PokemonDetails {
  final String name;
  final String imageUrl;
  final int id;
  final List<String> types;
  final int weight;
  final int height;
  final int baseExperience;
  final List<Map<String, dynamic>> abilities;
  final List<Map<String, dynamic>> stats;

  PokemonDetails({
    required this.name,
    required this.imageUrl,
    required this.id,
    required this.types,
    required this.weight,
    required this.height,
    required this.baseExperience,
    required this.abilities,
    required this.stats,
  });

factory PokemonDetails.fromJson(Map<String, dynamic> json) {
  List<dynamic> typesList = json['types'];
  List<String> types =
      typesList.map((type) => type['type']['name'] as String).toList();

  List<dynamic> abilitiesList = json['abilities'];
  List<Map<String, dynamic>> abilities = abilitiesList
      .map((ability) => ability['ability'])
      .toList().cast<Map<String, dynamic>>();

  List<dynamic> statsList = json['stats'];
  List<Map<String, dynamic>> stats = statsList
      .map((stat) => {
            'name': stat['stat']['name'],
            'base_stat': stat['base_stat'],
          })
      .toList().cast<Map<String, dynamic>>();

 

  return PokemonDetails(
    name: _capitalize(json['name']),
    imageUrl: json['sprites']['other']['home']['front_default'],
    id: json['id'],
    types: types,
    weight: json['weight'],
    height: json['height'],
    baseExperience: json['base_experience'],
    abilities: abilities,
    stats: stats,
  );
}


  static String _capitalize(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }
}
