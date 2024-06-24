import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constans/models/pokemon_details_model.dart';

class Stat extends StatelessWidget {
  const Stat({Key? key, required this.pokemonDetail}) : super(key: key);

  final PokemonDetails pokemonDetail;

  @override
  Widget build(BuildContext context) {
    List<Widget> statWidgets = [];

    for (final stat in pokemonDetail.stats) {
      statWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${stat['name']}', // Pokémon statisztikái
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: (stat['base_stat'] as int) / 100.0, // Statisztikák vizuális megjelenítése
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ],
          ),
        ),
      );
    }

    return Column(    
      children: statWidgets,
    );
  }
}
