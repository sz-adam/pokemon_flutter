import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/models/pokemon_color.dart';
import 'package:flutter_pokemon/constants/models/pokemon_details_model.dart';

class Stat extends StatelessWidget {
  const Stat({Key? key, required this.pokemonDetail}) : super(key: key);

  final PokemonDetails pokemonDetail;

  @override
  Widget build(BuildContext context) {
    List<Widget> statWidgets = [];

//ha a types nem üres akkor a 0 indexet használja ha üres akkor a 'normal
    final String statColor = pokemonDetail.types.isNotEmpty
        ? pokemonDetail.types[0].toLowerCase()
        : 'normal';
    final Color typeColor = PokeColors[statColor] ?? Colors.grey;

    for (final stat in pokemonDetail.stats) {
      statWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${stat['name']}', // Pokémon statisztikái
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 4),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                    begin: 0, end: (stat['base_stat'] as int) / 100.0),
                duration: const Duration(seconds: 1),
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value, // Statisztikák vizuális megjelenítése
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(typeColor),
                  );
                },
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
