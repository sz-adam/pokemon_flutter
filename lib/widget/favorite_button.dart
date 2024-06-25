import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton(
      {Key? key, required this.top, required this.right, required this.size})
      : super(key: key);

      final double top;
      final double right;
      final double size;

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isStarred = false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      right: widget.right,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isStarred = !isStarred;
          });
        },
        child: Icon(
          isStarred ? Icons.star : Icons.star_border,
          color: Colors.amber[700],
          size: widget.size,
        ),
      ),
    );
  }
}
