import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/models/pokemon_model.dart';
import 'package:flutter_pokemon/constants/services/poke_generation.dart';
import 'package:flutter_pokemon/controller/scroll_controller.dart';
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
  late PokeGenerationService pokemonService;
  late PaginationController paginationController;

  @override
  void initState() {
    super.initState();
    pokemonService = PokeGenerationService();
    paginationController = PaginationController(limit: 20);
    paginationController.addScrollListener(_loadMorePokemons);
    fetchPokemonGeneration();
  }

  @override
  void dispose() {
    paginationController.dispose(); // Tisztítja a görgetési vezérlőt
    super.dispose();
  }

  Future<void> fetchPokemonGeneration() async {
    if (paginationController.isLoading) return;
    setState(() {
      paginationController.isLoading = true;
    });

    try {
      final fetchedPokemons = await pokemonService.fetchPokemonGeneration(
        widget.generationUrl,
        paginationController.offset,
        paginationController.limit,
      );
      setState(() {
        pokemons.addAll(fetchedPokemons);
        paginationController.offset += paginationController.limit;
        paginationController.isLoading = false;
      });
    } catch (error) {
      print('Error fetching Pokémon data: $error');
      setState(() {
        paginationController.isLoading = false;
      });
    }
  }

  void _loadMorePokemons() {
    if (!paginationController.isLoading) {
      fetchPokemonGeneration();
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
      body: pokemons.isEmpty && paginationController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: paginationController.scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount:
                  pokemons.length + (paginationController.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == pokemons.length) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final pokemon = pokemons[index];
                  return PokemonCard(pokemon: pokemon);
                }
              },
            ),
    );
  }
}
