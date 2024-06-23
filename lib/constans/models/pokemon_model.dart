class Pokemon {
  final String name;
  final String imageUrl;
  final int id;

  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.id
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: _capitalize(json['name']),
      imageUrl: json['sprites']['front_default'],
      id:json['id'],
    );
  }
  //name nagybetűsé tétele 
  static String _capitalize(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }
}
