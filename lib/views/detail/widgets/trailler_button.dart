import 'package:flutter/material.dart';

class TrailerButton extends StatelessWidget {
  final String filmId;

  const TrailerButton({Key? key, required this.filmId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: arahkan ke halaman trailer (misalnya buka YouTube)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Trailer untuk film $filmId belum tersedia")),
        );
      },
      icon: const Icon(Icons.play_arrow),
      label: const Text("Watch Trailer"),
    );
  }
}
