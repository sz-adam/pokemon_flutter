import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/models/generation.dart';
import 'package:flutter_pokemon/constants/services/poke_service.dart';

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
        title: const Center(child: Text('Pokemon Generations')),
      ),
      body: FutureBuilder<List<Generation>>(
        future: _generations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No generations found'));
          } else {
            final generations = snapshot.data!;
            return ListView.builder(
              itemCount: generations.length,
              itemBuilder: (context, index) {
                final generation = generations[index];
                return ListTile(
                  title: Text(generation.name),
                );
              },
            );
          }
        },
      ),
    );
  }
}
