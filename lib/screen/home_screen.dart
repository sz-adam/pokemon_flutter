import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/provider/pokemon_provider.dart';
import 'package:flutter_pokemon/widget/card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
 
  bool _isLoading = false;
  int _offset = 0;
  final int _limit = 20;
  final ScrollController _scrollController =
      ScrollController(); // Görgetés vezérlő a lista nézethez

  @override
  void initState() {
    super.initState();
    _fetchPokemons(); // Betölti az első 20 Pokémon-t
    _scrollController
        .addListener(_scrollListener); // Hozzáad egy görgetési figyelőt
  }

  // Metódus a Pokémon-ok betöltésére
  Future<void> _fetchPokemons() async {
    if (_isLoading) return; // Ha már történik betöltés, akkor kilép
    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(pokemonListProvider.notifier)
          .fetchPokemons(limit: _limit, offset: _offset);
      setState(() {
        _offset += _limit; // Növeli az offsetet a következő betöltéshez
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Görgetési figyelő
  void _scrollListener() {
    if (_scrollController.position.extentAfter < 500 && !_isLoading) {
      _fetchPokemons(); // Új Pokémonok betöltése
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Tisztítja a görgetési vezérlőt
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
      body: pokemons.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Két kártya egymás mellé
                crossAxisSpacing: 8, // Vízszintes térköz a kártyák között
                mainAxisSpacing: 8, // Függőleges térköz a kártyák között
                childAspectRatio: 0.7, // Kártyák méretaránya (négyzet alakú)
              ),
              itemCount: pokemons.length +
                  (_isLoading
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
