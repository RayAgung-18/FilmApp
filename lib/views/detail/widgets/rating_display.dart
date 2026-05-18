import 'package:flutter/material.dart';

class RatingDisplay extends StatelessWidget {
  final double rating;

  const RatingDisplay({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.star, color: Colors.amber, size: 24),
        const SizedBox(width: 4),
        Text(
          "$rating/10",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
