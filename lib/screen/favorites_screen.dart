import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/provider/favorites_provider.dart';
import 'package:flutter_pokemon/widget/card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritePokemons = ref.watch(favoritesPokemonProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(
            'Favorites',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ),
      ),
      body: favoritePokemons.isEmpty
          ? Center(
              child: Text(
                'No favorites yet.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Két kártya egymás mellé
                crossAxisSpacing: 8, // Vízszintes térköz a kártyák között
                mainAxisSpacing: 8, // Függőleges térköz a kártyák között
                childAspectRatio: 0.7, // Kártyák méretaránya (négyzet alakú)
              ),             
              itemCount: favoritePokemons.length,
              itemBuilder: (context, index) {
                final pokemon = favoritePokemons[index];
                return PokemonCard(pokemon: pokemon);
              },
            ),
    );
  }
}
