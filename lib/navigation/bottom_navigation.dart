import 'package:flutter/material.dart';
import 'package:flutter_pokemon/screen/favorites_screen.dart';
import 'package:flutter_pokemon/screen/genration_screen.dart';
import 'package:flutter_pokemon/screen/home_screen.dart';
import 'package:flutter_pokemon/screen/search_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    GenerationsScreen(),
    const SearchScreen(),
    const FavoritesScreen(),
  ];

  final List<Map<String, dynamic>> _bottomNavItems = [
    {
      'icon': Icons.home,
      'label': 'Pokémon',
      'color': const Color.fromARGB(255, 214, 236, 17)
    },
    {'icon': Icons.grid_on, 'label': 'Generation', 'color': Colors.green},
    {'icon': Icons.favorite, 'label': 'Favorites', 'color': Colors.red},
    {'icon': Icons.search, 'label': 'Search', 'color': Colors.lightBlueAccent},
  ];

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
        items: _bottomNavItems.map((item) {
          final index = _bottomNavItems.indexOf(item);
          return BottomNavigationBarItem(
            icon: Icon(
              item['icon'],
              color: _selectedPageIndex == index ? item['color'] : Colors.grey,
            ),
            label: _selectedPageIndex == index ? item['label'] : '',
            backgroundColor: Theme.of(context).colorScheme.primary,
          );
        }).toList(),
      ),
    );
  }
}
