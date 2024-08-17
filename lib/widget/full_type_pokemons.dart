import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/models/pokemon_model.dart';
import 'package:flutter_pokemon/constants/services/poke_type.dart';
import 'package:flutter_pokemon/constants/utils/caracter_format.dart';
import 'package:flutter_pokemon/controller/scroll_controller.dart';
import 'package:flutter_pokemon/widget/card.dart';

class FullTypePokemons extends StatefulWidget {
  const FullTypePokemons({ Key? key, required this.typeUrl }) : super(key: key);

  final String typeUrl;

  @override
  _FullTypePokemonsState createState() => _FullTypePokemonsState();
}

class _FullTypePokemonsState extends State<FullTypePokemons> {
  List<Pokemon> typePokemons = [];
  late PokeTypeService pokemonService;
  late PaginationController paginationController;
  String typeName = '';

  @override
  void initState() {
    super.initState();
    pokemonService = PokeTypeService();
    paginationController = PaginationController(limit: 20);
    paginationController.addScrollListener(_loadMorePokemons);
    fetchTypeName(); // Lekérjük a típus nevét
    fetchPokemonType(); // Lekérjük a Pokémonokat
  }

  Future<void> fetchTypeName() async {
    try {
      final name = await pokemonService.fetchTypeName(widget.typeUrl);
      setState(() {
        typeName = name; // Frissítjük az állapotot a névvel
      });
    } catch (error) {
      print('Error fetching type name: $error');
    }
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
    // A capitalize függvény
    String capitalizedName = capitalize(typeName);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(
            'Pokemon Type: $capitalizedName', 
            style: const TextStyle(color: Colors.white),
          ),
        ),
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
              itemCount:
                  typePokemons.length + (paginationController.isLoading ? 1 : 0),
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
