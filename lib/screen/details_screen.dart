import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/provider/details_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pokemon/constants/models/pokemon_model.dart';
import 'package:flutter_pokemon/widget/custom_back_button.dart';
import 'package:flutter_pokemon/widget/favorite_button.dart';
import 'package:flutter_pokemon/widget/stat.dart';
import 'package:flutter_pokemon/widget/type.dart';

class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({
    Key? key,
    required this.pokemonId,
    required this.backgroundColor,
    required this.pokemon,
  }) : super(key: key);

  final int pokemonId;
  final Color backgroundColor;
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonDetailsAsyncValue =
        ref.watch(pokemonDetailsProvider(pokemonId));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      body: pokemonDetailsAsyncValue.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => const Center(
          child: Text('Failed to load Pokemon details'),
        ),
        data: (pokemonDetail) {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      color: backgroundColor,
                      child: Hero(
                        tag: pokemonDetail.id,
                        child: Image.network(pokemonDetail.imageUrl),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              pokemonDetail.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Type(pokemonDetail: pokemonDetail),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Height: ${(pokemonDetail.height / 10).toStringAsFixed(1)} m',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  'Weight :${(pokemonDetail.weight / 10).toStringAsFixed(1)} kg',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                pokemonDetail.description,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Stat(pokemonDetail: pokemonDetail),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              FavoriteButton(top: 30, right: 10, size: 30, pokemon: pokemon),
              const CustomBackButton(top: 30, left: 10),
            ],
          );
        },
      ),
    );
  }
}
