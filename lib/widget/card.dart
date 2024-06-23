import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constans/models/pokemon_color.dart';
import 'package:flutter_pokemon/constans/models/pokemon_model.dart';
import 'package:flutter_pokemon/screen/details_screen.dart';

class PokemonCard extends StatefulWidget {
  const PokemonCard({Key? key, required this.pokemon}) : super(key: key);

  final Pokemon pokemon;

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  bool isStarred = false;

  void _handleCardTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          pokemonId: widget.pokemon.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String firstType1 = widget.pokemon.types[0].toLowerCase();
    Color backgroundColor = PokeColors[firstType1] ?? Colors.grey;

    return GestureDetector(
      onTap: _handleCardTap,
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isStarred = !isStarred;
                        });
                      },
                      child: Icon(
                        isStarred ? Icons.star : Icons.star_border,
                        color: Colors.amber[700],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Image.network(
                  widget.pokemon.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
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
