import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constans/models/pokemon_details_model.dart';
import 'package:flutter_pokemon/constans/services/poke_service.dart';
import 'package:flutter_pokemon/widget/custom_back_button.dart';
import 'package:flutter_pokemon/widget/favorite_button.dart';
import 'package:flutter_pokemon/widget/stat.dart';
import 'package:flutter_pokemon/widget/type.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen(
      {Key? key, required this.pokemonId, required this.backgroundColor})
      : super(key: key);
  final int pokemonId;
  final Color backgroundColor;
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<PokemonDetails> _pokemonDetailsFuture;
  final PokeApiService _apiService = PokeApiService();

  @override
  void initState() {
    super.initState();
    _pokemonDetailsFuture = _apiService.fetchPokemonById(widget.pokemonId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      body: FutureBuilder<PokemonDetails>(
        future: _pokemonDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PokemonDetails pokemonDetail = snapshot.data!;
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        color: widget.backgroundColor,
                        child: Hero(
                            tag: pokemonDetail.id,
                            child: Image.network(pokemonDetail.imageUrl)),
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Type(pokemonDetail: pokemonDetail),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Height: ${(pokemonDetail.height / 10).toStringAsFixed(1)} m',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Weight :${(pokemonDetail.weight / 10).toStringAsFixed(1)} kg',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ],
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
                const FavoriteButton(top: 30, right: 10, size: 30),
               const  CustomBackButton(top: 30, left:10)
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load Pokemon details'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
