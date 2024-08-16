import 'package:flutter/material.dart';
import 'package:flutter_pokemon/widget/generation_details.dart';

class GenerationsCard extends StatelessWidget {
  const GenerationsCard({
    super.key,
    required this.backgroundColorgeneration,
    required this.formattedName,
    required this.generationUrl,
  });

  final Color backgroundColorgeneration;
  final String formattedName;
  final String generationUrl;


 @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigálás a részletező képernyőre
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>GenerationDetailsScreen(
              generationUrl: generationUrl,
            ),
          ),
        );
      },
      child: Card(
        color: backgroundColorgeneration,
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
                formattedName,
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