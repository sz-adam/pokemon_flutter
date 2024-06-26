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
  final String description;

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
    required this.description,
  });

  factory PokemonDetails.fromJson(
      Map<String, dynamic> pokemonJson, Map<String, dynamic> speciesJson) {
        //type 
    List<dynamic> typesList = pokemonJson['types'];
    List<String> types = typesList
        .map((type) => _capitalize(type['type']['name'] as String))
        .toList();

        //ability
    List<dynamic> abilitiesList = pokemonJson['abilities'];
    List<Map<String, dynamic>> abilities = abilitiesList
        .map((ability) => ability['ability'])
        .toList()
        .cast<Map<String, dynamic>>();

        //stat
    List<dynamic> statsList = pokemonJson['stats'];
    List<Map<String, dynamic>> stats = statsList
        .map((stat) => {
              'name': _capitalize(stat['stat']['name']),
              'base_stat': stat['base_stat'],
            })
        .toList()
        .cast<Map<String, dynamic>>();

        //description
    String description = speciesJson['flavor_text_entries'].firstWhere(
        (entry) => entry['language']['name'] == 'en')['flavor_text'].replaceAll("\n", '').replaceAll('\f', '');

    return PokemonDetails(
      name: _capitalize(pokemonJson['name']),
      imageUrl: pokemonJson['sprites']['other']['home']['front_default'],
      id: pokemonJson['id'],
      types: types,
      weight: pokemonJson['weight'],
      height: pokemonJson['height'],
      baseExperience: pokemonJson['base_experience'],
      abilities: abilities,
      stats: stats,
      description: description,
    );
  }
    //segédfügvény Nagybetű
  static String _capitalize(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }
}
