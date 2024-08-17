import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/services/poke_service.dart';
import 'package:flutter_pokemon/widget/card.dart';
import 'package:flutter_pokemon/constants/models/pokemon_model.dart';

class FullTypePokemons extends StatefulWidget {
  const FullTypePokemons({Key? key, required this.typeUrl}) : super(key: key);

  final String typeUrl;

  @override
  _FullTypePokemonsState createState() => _FullTypePokemonsState();
}

class _FullTypePokemonsState extends State<FullTypePokemons> {
  late Future<List<Pokemon>> _futurePokemons;
  final PokeApiService _pokemonService = PokeApiService();

  @override
  void initState() {
    super.initState();
    _futurePokemons = _pokemonService.fetchTypePokemons(widget.typeUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Pokemons by Type',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: _futurePokemons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Pokémon found.'));
          } else {
            final pokemons = snapshot.data!;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Két oszlopos grid
                crossAxisSpacing: 8.0, // Oszlopok közötti távolság
                mainAxisSpacing: 8.0, // Sorok közötti távolság
              ),
              padding: const EdgeInsets.all(8.0),
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];
                return PokemonCard(
                  pokemon: pokemon,
                );
              },
            );
          }
        },
      ),
    );
  }
}
