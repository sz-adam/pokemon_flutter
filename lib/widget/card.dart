import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constans/models/pokemon_color.dart';
import 'package:flutter_pokemon/constans/models/pokemon_model.dart';
import 'package:flutter_pokemon/screen/details_screen.dart';
import 'package:flutter_pokemon/widget/favorite_button.dart';

class PokemonCard extends StatefulWidget {
  const PokemonCard({Key? key, required this.pokemon}) : super(key: key);

  final Pokemon pokemon;

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {


  @override
  Widget build(BuildContext context) {
    String firstType1 = widget.pokemon.types[0].toLowerCase();
    Color backgroundColor = PokeColors[firstType1] ?? Colors.grey;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              pokemonId: widget.pokemon.id,
              backgroundColor: backgroundColor,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: backgroundColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(2),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.pokemon.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  const  FavoriteButton(top: 30, right: 10, size: 25)
                  ],
                ),
              ),
              Expanded(
                child: Hero(
                  tag: widget.pokemon.id,
                  child: Image.network(
                    widget.pokemon.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.pokemon.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
