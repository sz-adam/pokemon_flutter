import 'package:flutter_pokemon/constants/models/full_type_model.dart';
import 'package:flutter_pokemon/constants/models/pokemon_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // A JSON dekódolásához szükséges

class PokeTypeService{
    final String baseUrl = 'https://pokeapi.co/api/v2/pokemon';
      final String fullTypeUrl = 'https://pokeapi.co/api/v2/type/';

 //összes tipus lekérése
  Future<List<FullTypeModel>> fetchFullTypes() async {
    final response = await http.get(Uri.parse(fullTypeUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;
      return results.map((json) => FullTypeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load types');
    }
  }

  Future<String> fetchTypeName(String typeUrl) async {
    try {
      final response = await http.get(Uri.parse(typeUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Kinyerjük a "name" mezőt
        final typeName = data['name'];
        return typeName;
      } else {
        throw Exception('Failed to load type name');
      }
    } catch (error) {
      print('Error in fetchTypeName: $error');
      rethrow;
    }
  }

  ///Tipus alpaján lekérjük a pokemonokat
  Future<List<Pokemon>> fetchPokemonType(
      String typeUrl, int offset, int limit) async {
    try {
      final response = await http.get(Uri.parse(typeUrl));
      if (response.statusCode == 200) {
        // A választ dekódoljuk
        final data = jsonDecode(response.body);
        // Kinyerjük az ID-kat az 'pokemon' listából
        final List<String> ids = _extractTypeIds(data['pokemon']);
        // Szűrés az offset és limit alapján
        final paginatedIds = ids.skip(offset).take(limit).toList();
        // Lekérjük a Pokémonokat az ID-k alapján
        final pokemons = await _fetchPokemonsByTypeIds(paginatedIds);

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

// Segédfüggvény, amely kinyeri a Pokémon ID-kat a pokemon url-ből utolsó karakterek
  List<String> _extractTypeIds(List<dynamic> pokemonSpecies) {
    // Adjuk vissza a listát amelyben a Pokémon Url szerepelnek
    return pokemonSpecies.map((species) {
      // Kinyerjük az URL-t, majd az ID-t az URL-ből
      final url = species['pokemon']['url'];
      return _extractIdFromTypeUrl(url);
    }).toList();
  }

// Segédfüggvény, amely kinyeri az ID-t az URL-ből
  String _extractIdFromTypeUrl(String url) {
    // Az URL-t '/' karakterek mentén felbontjuk
    final parts = url.split('/');
    // Az ID az utolsó előtti elem az URL-ban
    return parts[parts.length - 2];
  }

// Segédfüggvény, amely lekéri az egyes Pokémonokat az ID-k alapján
  Future<List<Pokemon>> _fetchPokemonsByTypeIds(List<String> ids) async {
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
}