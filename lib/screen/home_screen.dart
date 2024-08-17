import 'package:flutter/material.dart';
import 'package:flutter_pokemon/controller/scroll_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pokemon/constants/provider/pokemon_provider.dart';
import 'package:flutter_pokemon/widget/card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PaginationController _paginationController =
      PaginationController(limit: 20);

  @override
  void initState() {
    super.initState();
    _paginationController.addScrollListener(_fetchPokemons);
    _fetchPokemons(); // Betölti az első 20 Pokémon-t
  }

// Metódus a Pokémon-ok betöltésére
  Future<void> _fetchPokemons() async {
    if (_paginationController.isLoading)
      return; // Ha már történik betöltés, akkor kilép

    setState(() {
      _paginationController.isLoading = true;
    });

    try {
      await ref.read(pokemonListProvider.notifier).fetchPokemons(
          limit: _paginationController.limit,
          offset: _paginationController.offset);
      setState(() {
        _paginationController.offset += _paginationController
            .limit; // Növeli az offsetet a következő betöltéshez
        _paginationController.isLoading = false;
      });
    } catch (e) {
      setState(() {
        _paginationController.isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _paginationController.dispose(); // Tisztítja a görgetési vezérlőt
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pokemons = ref.watch(pokemonListProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(
            'Pokemon Codex',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ),
      ),
      body: pokemons.isEmpty && _paginationController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: _paginationController.scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Az oszlopok száma a rácsban
                crossAxisSpacing: 8, // Az oszlopok közötti távolság
                mainAxisSpacing: 8, // A sorok közötti távolság
                childAspectRatio: 0.7,
              ),
              itemCount: pokemons.length +
                  (_paginationController.isLoading
                      ? 1
                      : 0), // Hozzáad egy betöltési indikátort, ha éppen töltés történik
              itemBuilder: (context, index) {
                if (index == pokemons.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  ); // Betöltési indikátor a lista végén
                }
                final pokemon = pokemons[index];
                return PokemonCard(
                    pokemon: pokemon); // Pokemon kártya megjelenítése
              },
            ),
    );
  }
}
