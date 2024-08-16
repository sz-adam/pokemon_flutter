import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/models/pokemon_model.dart';
import 'package:flutter_pokemon/constants/services/poke_service.dart';
import 'package:flutter_pokemon/widget/card.dart';

class GenerationDetailsScreen extends StatefulWidget {
  final String generationUrl;

  const GenerationDetailsScreen({
    super.key,
    required this.generationUrl,
  });

  @override
  State<GenerationDetailsScreen> createState() =>
      _GenerationDetailsScreenState();
}

class _GenerationDetailsScreenState extends State<GenerationDetailsScreen> {
  List<Pokemon> pokemons = [];

  late PokeApiService pokemonService;

  @override
  void initState() {
    super.initState();
    pokemonService = PokeApiService();
    fetchPokemonGeneration();
  }

  Future<void> fetchPokemonGeneration() async {
    try {
      final fetchedPokemons =
          await pokemonService.fetchPokemonGeneration(widget.generationUrl);
      setState(() {
        pokemons = fetchedPokemons;
      });
    } catch (error) {
      print('Error fetching Pokémon data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
            child: Text(
          'Pokemon Generation',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Az oszlopok száma a rácsban
          crossAxisSpacing: 8, // Az oszlopok közötti távolság
          mainAxisSpacing: 8, // A sorok közötti távolság
          childAspectRatio: 0.7,
        ),
        itemCount: pokemons.length,
        itemBuilder: (context, index) {
          final pokemon = pokemons[index];
          return PokemonCard(pokemon: pokemon);
        },
      ),
    );
  }
}
