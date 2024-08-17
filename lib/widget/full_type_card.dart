import 'package:flutter/material.dart';
import 'package:flutter_pokemon/constants/models/full_type_model.dart';
import 'package:flutter_pokemon/constants/models/pokemon_color.dart';
import 'package:flutter_pokemon/constants/utils/caracter_format.dart';
import 'package:flutter_pokemon/widget/full_type_pokemons.dart';

class FullTypeCard extends StatelessWidget {
  const FullTypeCard({Key? key, required this.fullTypes}) : super(key: key);

  final FullTypeModel fullTypes;

  

  @override
  Widget build(BuildContext context) {
    String name = fullTypes.name;
      String capitalizedName = capitalize(name); 
    Color backgroundColor = PokeColors[name] ?? Colors.grey;
 
  

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullTypePokemons(
              typeUrl:fullTypes.url
            ),
          ),
        );
      },
      child: Card(
        color: backgroundColor,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/pokeball.png',
              height: 150,
              width: 150,
              color: Colors.white24,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 50,
              child: Text(
                capitalizedName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
