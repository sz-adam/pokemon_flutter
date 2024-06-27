import 'package:flutter_pokemon/constants/models/pokemon_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePokemonNotifier extends StateNotifier<List<Pokemon>> {
  FavoritePokemonNotifier() : super([]);

//provider nélkül meglévő objektumot szerkeszthet memorában , provideren belül ez NEM megengedett
  bool togglePokemonFavoritStatus(Pokemon pokemon) {
    // Ellenőrizzük, hogy az adott pokemon benne van-e a kedvencek listájában
    final PokemonIsFavorite = state.contains(pokemon);

    if (PokemonIsFavorite) {
      // Ha az pokemon már benne van a kedvencek között, akkor eltávolítjuk azt
      // A `where` függvény segítségével egy új listát hozunk létre, amelyből kihagyjuk az adott pokemont
      state = state.where((m) => m.id != pokemon.id).toList();
      return false;
    } else {
      // Ha az pokemon nincs benne a kedvencek között, akkor hozzáadjuk azt
      // Az új pokemont hozzáadjuk a meglévő kedvencek listájához
      state = [...state, pokemon];
      return true;
    }
  }
}

//StateNotifierProvider olyan adatokhoz használják amik változhatnak
final favoritesPokemonProvider = StateNotifierProvider<FavoritePokemonNotifier, List<Pokemon>>((ref) {
  return FavoritePokemonNotifier();
});
