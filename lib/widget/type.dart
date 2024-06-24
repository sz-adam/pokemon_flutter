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
        Color textColor =
            type.toLowerCase() == 'electric' ? Colors.black87 : Colors.white;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            type,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        );
      }).toList(),
    );
  }
}
