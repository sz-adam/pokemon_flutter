import 'dart:convert'; // A JSON dekódolásához szükséges
import 'package:flutter_pokemon/constants/models/pokemon_details_model.dart';
import 'package:flutter_pokemon/constants/models/pokemon_model.dart';
import 'package:http/http.dart' as http;

class PokeApiService {
  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon';
  final String speciesUrl = 'https://pokeapi.co/api/v2/pokemon-species';

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
    final pokemonResponse = await http.get(Uri.parse('$baseUrl/$id'));
    final speciesResponse = await http.get(Uri.parse('$speciesUrl/$id'));

    if (pokemonResponse.statusCode == 200 &&
        speciesResponse.statusCode == 200) {
      final pokemonData = jsonDecode(pokemonResponse.body);
      final speciesData = jsonDecode(speciesResponse.body);
      return PokemonDetails.fromJson(pokemonData, speciesData);
    } else {
      throw Exception('Failed to load Pokémon by ID');
    }
  }

//search
  Future<List<Pokemon>> searchPokemons(String query) async {
    final url = '$baseUrl?limit=1000';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      List<Pokemon> pokemons = [];
      //TODO:Ha a lekért pokemon neve megyezik a query-be szereplő névvel
      for (var result in results) {
        if (result['name'].startsWith(query.toLowerCase())) {
          final pokemonDetail = await fetchPokemonDetail(result['url']);
          pokemons.add(pokemonDetail);
        }
      }

      return pokemons;
    } else {
      throw Exception('Failed to search pokemons');
    }
  }
}
