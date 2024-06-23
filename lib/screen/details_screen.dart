import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constans/models/pokemon_details_model.dart';
import 'package:flutter_pokemon/constans/services/poke_service.dart';
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
      appBar: AppBar(
        title: Text('Pokemon Details'),
      ),
      body: FutureBuilder<PokemonDetails>(
        future: _pokemonDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PokemonDetails pokemonDetail = snapshot.data!;
            return Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      color:widget.backgroundColor,
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
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 20),
                            Type(pokemonDetail: pokemonDetail)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load Pokemon details'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
