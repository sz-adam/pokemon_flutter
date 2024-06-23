import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constans/models/pokemon_color.dart';
import 'package:flutter_pokemon/constans/models/pokemon_details_model.dart';

class Type extends StatelessWidget {
  const Type({Key? key, required this.pokemonDetail}) : super(key: key);
  final PokemonDetails pokemonDetail;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: pokemonDetail.types.map((type) {
        Color backgroundColor = PokeColors[type.toLowerCase()] ?? Colors.grey;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            type,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        );
      }).toList(),
    );
  }
}
