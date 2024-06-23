import 'package:flutter/material.dart';
import 'package:flutter_pokemon/screen/favorites_screen.dart';
import 'package:flutter_pokemon/screen/home_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [HomeScreen(), FavoritesScreen()];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _selectedPageIndex == 0
                  ? Color.fromARGB(255, 214, 236, 17)
                  : Colors.grey,
            ),
            label: _selectedPageIndex == 0 ? 'Pokémon' : '',
            backgroundColor:
                Theme.of(context).colorScheme.onPrimaryFixedVariant,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: _selectedPageIndex == 1 ? Colors.red : Colors.grey,
            ),
            label: _selectedPageIndex == 1 ? 'Favorites' : '',
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
