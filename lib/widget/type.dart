import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constans/models/pokemon_details_model.dart';

class Type extends StatelessWidget {
  const Type({Key? key, required this.pokemonDetail}) : super(key: key);
  final PokemonDetails pokemonDetail;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (pokemonDetail.types.length > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(16)),
            child: Text(
              pokemonDetail.types[0],
            ),
          ),
        if (pokemonDetail.types.length > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              pokemonDetail.types[1],
            ),
          ),
      ],
    );
  }
}
