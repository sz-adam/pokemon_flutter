import 'package:flutter_pokemon/constants/models/pokemon_model.dart';
import 'package:flutter_pokemon/constants/services/poke_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PokemonListNotifier extends StateNotifier<List<Pokemon>> {
  PokemonListNotifier() : super([]);

  Future<void> fetchPokemons({required int limit, required int offset}) async {
    final newPokemons =
        await PokeApiService().fetchPokemons(limit: limit, offset: offset);
         // Frissítjük az állapotot az új Pokémonok hozzáadásával a meglévő listához
    state = [...state, ...newPokemons];
  }
}

final pokemonListProvider =
    StateNotifierProvider<PokemonListNotifier, List<Pokemon>>((ref) {
  return PokemonListNotifier();
});
