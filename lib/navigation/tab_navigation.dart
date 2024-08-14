import 'package:flutter/material.dart';
import 'package:flutter_pokemon/widget/generations.dart';


class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // A tabok száma

      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          bottom:const TabBar(
            indicatorColor: Colors.blue, // Aktív tab alatti vonal színe
            tabs: [
              Tab(
                icon: Icon(
                  Icons.history,
                  color: Colors.white, // Ikon színe
                ),
                child: Text(
                  'Generation',
                  style: TextStyle(color: Colors.white), // Szöveg színe
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.filter_list,
                  color: Colors.white, // Ikon színe
                ),
                child: Text(
                  'Type',
                  style: TextStyle(color: Colors.white), // Szöveg színe
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Generációk tartalma
            Center(child: Generations()),
            // Típusok tartalma
            Center(child: Text('Pokémon Types Content')),
          ],
        ),
      ),
    );
  }
}
