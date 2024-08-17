import 'package:flutter_pokemon/constants/utils/caracter_format.dart';

class Pokemon {
  final String name;
  final String imageUrl;
  final int id;
  final List<String> types;

  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.id,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // A 'types' listából dinamikus objektumok listáját olvassuk be
    List<dynamic> typesList = json['types'];

    // A 'typesList' elemeit átalakítjuk String típusú listává, ahol minden elemet
    // kinyerünk a 'type' kulcsból a 'name' alapján. Az 'as String' biztosítja, hogy
    // minden elem String típusú legyen, amit a 'toList()' metódussal konvertálunk.
    List<String> types =
        typesList.map((type) => type['type']['name'] as String).toList();

    return Pokemon(
      name: capitalize(json['name']),
      imageUrl: json['sprites']['other']['home']['front_default'],
      id: json['id'],
      types: types,
    );
  }

}
