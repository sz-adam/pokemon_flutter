import 'package:flutter/material.dart';

class GenerationsCard extends StatelessWidget {
  const GenerationsCard({
    super.key,
    required this.backgroundColorgeneration,
    required this.formattedName,
  });

  final Color backgroundColorgeneration;
  final String formattedName;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
