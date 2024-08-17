import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/models/full_type_model.dart';
import 'package:flutter_pokemon/constants/services/poke_service.dart';
import 'package:flutter_pokemon/widget/full_type_card.dart';

class TypeCard extends StatefulWidget {
  const TypeCard({Key? key}) : super(key: key);

  @override
  _TypeCardState createState() => _TypeCardState();
}

class _TypeCardState extends State<TypeCard> {
  late Future<List<FullTypeModel>> _fullType;

  @override
  void initState() {
    super.initState();
    _fullType = PokeApiService().fetchFullTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
          child: Text(
            'Pokemon Types',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
       body: FutureBuilder<List<FullTypeModel>>(
        future: _fullType,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Betöltésjelző megjelenítése az adatok lekérése közben
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Hiba esetén hibaüzenet megjelenítése
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Ha nincsenek generációk
            return const Center(child: Text('No fulltype found'));
          } else {
            // adatok megjelenítése
            final fullType = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Két kártya egymás mellé
                crossAxisSpacing: 8, // Vízszintes térköz a kártyák között
                mainAxisSpacing: 8, // Függőleges térköz a kártyák között
                childAspectRatio: 1.5, // Kártyák méretaránya
              ),
              itemCount: fullType.length,
              itemBuilder: (context, index) {
                final fullTypes = fullType[index];
               
                return FullTypeCard(fullTypes:fullTypes);
              },
            );
          }
        },
      ),
    );
  }
}
