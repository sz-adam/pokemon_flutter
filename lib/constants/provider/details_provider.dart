import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pokemon/constants/models/pokemon_details_model.dart';
import 'package:flutter_pokemon/constants/services/poke_service.dart';

final pokemonDetailsProvider = FutureProvider.family<PokemonDetails, int>((ref, pokemonId) async {
  final apiService = PokeApiService();
  return await apiService.fetchPokemonById(pokemonId);
});
