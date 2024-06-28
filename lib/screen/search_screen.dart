import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/models/pokemon_model.dart';
import 'package:flutter_pokemon/constants/services/poke_service.dart';
import 'package:flutter_pokemon/widget/card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PokeApiService _apiService = PokeApiService();
  List<Pokemon> searchResults = [];

  void _searchPokemon(String query) async {
    //TODO: ha üres töröld a keresési listát
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }
    List<Pokemon> results = await _apiService.searchPokemons(query);
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(
            'Pokemon Search',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _searchPokemon,
              decoration: const InputDecoration(
                labelText: 'Search Pokemon...',
                labelStyle: TextStyle(color: Colors.lightBlueAccent),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.lightBlueAccent,
                ),              
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: searchResults.isEmpty
                ? Center(
                    child: Text(
                      'No searched yet.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final pokemon = searchResults[index];
                      return PokemonCard(pokemon: pokemon);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
