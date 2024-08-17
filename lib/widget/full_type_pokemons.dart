import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/models/pokemon_model.dart';
import 'package:flutter_pokemon/constants/services/poke_service.dart';
import 'package:flutter_pokemon/controller/scroll_controller.dart';
import 'package:flutter_pokemon/widget/card.dart';

class FullTypePokemons extends StatefulWidget {
  const FullTypePokemons({Key? key, required this.typeUrl}) : super(key: key);

  final String typeUrl;

  @override
  _FullTypePokemonsState createState() => _FullTypePokemonsState();
}

class _FullTypePokemonsState extends State<FullTypePokemons> {
  List<Pokemon> typePokemons = [];
  late PokeApiService pokemonService;
  late PaginationController paginationController;

  @override
  void initState() {
    super.initState();
    pokemonService = PokeApiService();
    paginationController = PaginationController(limit: 20);
    paginationController.addScrollListener(_loadMorePokemons);
    fetchPokemonType();
  }

  Future<void> fetchPokemonType() async {
    if (paginationController.isLoading) return;
    setState(() {
      paginationController.isLoading = true;
    });

    try {
      final fetchedPokemons = await pokemonService.fetchPokemonType(
        widget.typeUrl,
        paginationController.offset,
        paginationController.limit,
      );
      setState(() {
        typePokemons.addAll(fetchedPokemons);
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
      fetchPokemonType();
    }
  }

  @override
  void dispose() {
    paginationController.dispose(); // Tisztítja a görgetési vezérlőt
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
            child: Text(
          'Pokemon types',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: typePokemons.isEmpty && paginationController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: paginationController.scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: typePokemons.length +
                  (paginationController.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == typePokemons.length) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final pokemon = typePokemons[index];
                  return PokemonCard(pokemon: pokemon);
                }
              },
            ),
    );
  }
}
