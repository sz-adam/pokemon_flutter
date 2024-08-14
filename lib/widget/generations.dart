import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/models/generation.dart';
import 'package:flutter_pokemon/constants/services/poke_service.dart';
import 'package:flutter_pokemon/constants/utils/caracter_format.dart';

class Generations extends StatefulWidget {
  @override
  _GenerationsState createState() => _GenerationsState();
}

class _GenerationsState extends State<Generations> {
  late Future<List<Generation>> _generations;

  @override
  void initState() {
    super.initState();
    _generations = PokeApiService().fetchGenerations();
  }

  @override
  Widget build(BuildContext context) {   
    return Scaffold(
       backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      appBar: AppBar(
         backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(child: Text('Pokemon Generations',style: TextStyle(color: Colors.white),)),
      ),
 body: FutureBuilder<List<Generation>>(
        future: _generations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Betöltésjelző megjelenítése az adatok lekérése közben
            return  const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Hiba esetén hibaüzenet megjelenítése
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Ha nincsenek generációk
            return  const Center(child: Text('No generations found'));
          } else {
            // adatok megjelenítése
            final generations = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Két kártya egymás mellé
                crossAxisSpacing: 8, // Vízszintes térköz a kártyák között
                mainAxisSpacing: 8, // Függőleges térköz a kártyák között
                childAspectRatio: 1.5, // Kártyák méretaránya
              ),
              itemCount: generations.length,
              itemBuilder: (context, index) {
                final generation = generations[index];
                final formattedName=formatGenerationName(generation.name);
                return Card(    
                    child: 
                      Center(
                        child: Text(
                          formattedName,
                          style:const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
