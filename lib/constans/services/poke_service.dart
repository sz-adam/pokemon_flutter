import 'dart:convert'; // A JSON dekódolásához szükséges
import 'package:flutter_pokemon/constans/models/pokemon_details_model.dart';
import 'package:flutter_pokemon/constans/models/pokemon_model.dart';
import 'package:http/http.dart' as http;

class PokeApiService {
  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  // pokemonok lekérése
  Future<List<Pokemon>> fetchPokemons({int limit = 20, int offset = 0}) async {
    final url = '$baseUrl?limit=$limit&offset=$offset';
    final response = await http.get(Uri.parse(url)); // HTTP GET kérés az URL-re
    if (response.statusCode == 200) {
      final data =
          jsonDecode(response.body); // A választ JSON objektummá dekódolja
      final List<dynamic> results =
          data['results']; // Kinyeri a 'results' listát a dekódolt adatból
      List<Pokemon> pokemons = []; // Üres lista a Pokémon objektumok tárolására
      for (var result in results) {
        // Iterál a 'results' lista elemein
        final pokemonDetail = await fetchPokemonDetail(result[
            'url']); // Lekéri a részletes adatokat az egyes Pokémon URL-ekről
        pokemons
            .add(pokemonDetail); // Hozzáadja a Pokémon objektumot a listához
      }
      return pokemons;
    } else {
      throw Exception('Failed to load pokemons');
    }
  }

  Future<Pokemon> fetchPokemonDetail(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Ellenőrzi, hogy a válasz státuszkódja 200 (sikeres) legyen
      final data = jsonDecode(
          response.body); // A válasz törzsét JSON objektummá dekódolja
      return Pokemon.fromJson(data);
    } else {
      throw Exception('Failed to load pokemon detail');
    }
  }

  Future<PokemonDetails> fetchPokemonById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PokemonDetails.fromJson(data);
    } else {
      throw Exception('Failed to load Pokémon by ID');
    }
  }
}
