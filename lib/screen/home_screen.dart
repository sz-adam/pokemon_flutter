import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constans/models/pokemon_model.dart';
import 'package:flutter_pokemon/constans/services/poke_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Pokemon> _pokemons = [];
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
      final newPokemons =
          await PokeApiService().fetchPokemons(limit: _limit, offset: _offset);
      setState(() {
        _pokemons.addAll(newPokemons); // Hozzáadja az új Pokémonokat a listához
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
      body: _pokemons.isEmpty && _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _pokemons.length +
                  (_isLoading
                      ? 1
                      : 0), // Hozzáad egy betöltési indikátort, ha éppen töltés történik
              itemBuilder: (context, index) {
                if (index == _pokemons.length) {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Betöltési indikátor a lista végén
                }
                final pokemon = _pokemons[index];
                return ListTile(
                  leading: Image.network(pokemon.imageUrl),
                  title: Text(pokemon.name),
                  subtitle: Text('ID: ${pokemon.id}'),
                );
              },
            ),
    );
  }
}
