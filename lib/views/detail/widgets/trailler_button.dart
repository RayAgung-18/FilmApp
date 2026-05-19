import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrailerButton extends StatelessWidget {
  final String trailerUrl;

  const TrailerButton({
    super.key,
    required this.trailerUrl,
  });

  Future<void> openTrailer(BuildContext context) async {
    try {

      // Cek jika URL kosong
      if (trailerUrl.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trailer tidak tersedia'),
          ),
        );
        return;
      }

      final Uri url = Uri.parse(trailerUrl);

      // Cek apakah URL valid
      if (!url.hasScheme) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Link trailer tidak valid'),
          ),
        );
        return;
      }

      // Buka trailer
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      // Jika gagal dibuka
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal membuka trailer'),
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat membuka trailer'),
        ),
      );

      print("ERROR TRAILER: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () => openTrailer(context),
        icon: const Icon(Icons.play_arrow),
        label: const Text("Watch Trailer"),
      ),
    );
  }
}