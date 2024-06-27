import 'package:flutter/material.dart';
import 'package:flutter_pokemon/navigation/bottom_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  runApp(
    //Az egész alkalmazás providerbe tétele , olyan mint a react contextus 
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData().copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 29, 132, 201)),
        ),
        home: BottomNavigation());
  }
}
