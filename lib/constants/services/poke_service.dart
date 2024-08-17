import 'dart:convert'; // A JSON dekódolásához szükséges
import 'package:flutter_pokemon/constants/models/full_type_model.dart';
import 'package:flutter_pokemon/constants/models/generation.dart';
import 'package:flutter_pokemon/constants/models/pokemon_details_model.dart';
import 'package:flutter_pokemon/constants/models/pokemon_model.dart';
import 'package:http/http.dart' as http;

class PokeApiService {
  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon';
  final String speciesUrl = 'https://pokeapi.co/api/v2/pokemon-species';
  final String generationUrl = 'https://pokeapi.co/api/v2/';
  final String fullTypeUrl='https://pokeapi.co/api/v2/type/';

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

  Future<List<Generation>> fetchGenerations() async {
    final response = await http.get(Uri.parse('${generationUrl}generation'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      return results.map((json) => Generation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load generations');
    }
  }

  // adott generációs Pokemonok lekérése
  Future<List<Pokemon>> fetchPokemonGeneration(
      String generationUrl, int offset, int limit) async {
    try {
      final response = await http.get(Uri.parse(generationUrl));
      if (response.statusCode == 200) {
        // A választ dekódoljuk
        final data = jsonDecode(response.body);
        // Kinyerjük az ID-kat az 'pokemon_species' listából
        final List<String> ids = _extractIds(data['pokemon_species']);
        // Szűrés az offset és limit alapján
        final paginatedIds = ids.skip(offset).take(limit).toList();
        // Lekérjük a Pokémonokat az ID-k alapján
        final pokemons = await _fetchPokemonsByIds(paginatedIds);

        // Visszaadjuk a lekért Pokémonokat
        return pokemons;
      } else {
        throw Exception('Failed to load generation data');
      }
    } catch (error) {
      print('Error in fetchPokemonGeneration: $error');
      rethrow;
    }
  }

// Segédfüggvény, amely kinyeri a Pokémon ID-kat a pokemon_species url-ből utolsó karakterek
  List<String> _extractIds(List<dynamic> pokemonSpecies) {
    // Adjuk vissza a listát amelyben a Pokémon Url szerepelnek
    return pokemonSpecies.map((species) {
      // Kinyerjük az URL-t, majd az ID-t az URL-ből
      final url = species['url'];
      return _extractIdFromUrl(url);
    }).toList();
  }

// Segédfüggvény, amely kinyeri az ID-t az URL-ből
  String _extractIdFromUrl(String url) {
    // Az URL-t '/' karakterek mentén felbontjuk
    final parts = url.split('/');
    // Az ID az utolsó előtti elem az URL-ban
    return parts[parts.length - 2];
  }

// Segédfüggvény, amely lekéri az egyes Pokémonokat az ID-k alapján
  Future<List<Pokemon>> _fetchPokemonsByIds(List<String> ids) async {
    List<Pokemon> pokemons = [];
    for (String id in ids) {
      try {
        final url = '$baseUrl/$id/';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          // A választ dekódoljuk
          final data = jsonDecode(response.body);
          // Létrehozzuk a Pokémon objektumot
          final pokemon = Pokemon.fromJson(data);
          pokemons.add(pokemon);
        } else {
          print('Failed to load Pokémon data for ID: $id');
        }
      } catch (error) {
        print('Error fetching Pokémon ID $id: $error');
      }
    }
    return pokemons;
  }


  //összes tipus lekérése 
   Future<List<FullTypeModel>> fetchFullTypes() async {
    final response = await http.get(Uri.parse('${fullTypeUrl}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;
      return results.map((json) => FullTypeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load types');
    }
  }
  
   // Lekérdezi a Pokémon típusokat
  Future<List<Pokemon>> fetchTypePokemons(String typeUrl) async {
    final response = await http.get(Uri.parse(typeUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> pokemonsData = data['pokemon'];

      List<Pokemon> pokemons = [];
      for (int i = 0; i < pokemonsData.length && i < 10; i++) {
        final pokemonData = pokemonsData[i];
        final pokemonUrl = pokemonData['pokemon']['url'];
        final pokemonResponse = await http.get(Uri.parse(pokemonUrl));

        if (pokemonResponse.statusCode == 200) {
          final pokemonJson = json.decode(pokemonResponse.body);
          pokemons.add(Pokemon.fromJson(pokemonJson));
        } else {
          throw Exception('Failed to load pokemon');
        }
      }
      return pokemons;
    } else {
      throw Exception('Failed to load pokemon list');
    }
  }

}
