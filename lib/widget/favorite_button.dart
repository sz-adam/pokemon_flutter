import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constans/models/pokemon_model.dart';
import 'package:flutter_pokemon/provider/favorites_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteButton extends ConsumerWidget {
  FavoriteButton(
      {Key? key, this.top, this.right, this.size, required this.pokemon})
      : super(key: key);

  final double? top;
  final double? right;
  final double? size;
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeal = ref.watch(favoritesPokemonProvider);

    final isFavorite = favoriteMeal.contains(pokemon);
    return Stack(children: [
      Positioned(
        top: top,
        right: right,
        child: IconButton(
          onPressed: () {
            final wasAdded = ref
                .watch(favoritesPokemonProvider.notifier)
                .togglePokemonFavoritStatus(
                    pokemon); //információs üzenet a törlésre
            ScaffoldMessenger.of(context).clearSnackBars();
            //információs üzenet a hozzáadásra
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(wasAdded
                    ? 'Pokemon addad as a favorite'
                    : 'Pokemon removed')));
          },
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: Colors.amber[700],
            size: size,
          ),
        ),
      ),
    ]);
  }
}
