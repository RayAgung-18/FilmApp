import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrailerButton extends StatelessWidget {
  final String trailerUrl;

  const TrailerButton({
    super.key,
    required this.trailerUrl,
  });

  Future<void> openTrailer() async {
    try {
      print("URL TRAILER: $trailerUrl");

      final Uri url = Uri.parse(trailerUrl);

      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      print("LAUNCHED: $launched");
    } catch (e) {
      print("ERROR TRAILER: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: openTrailer,
        icon: const Icon(Icons.play_arrow),
        label: const Text("Watch Trailer"),
      ),
    );
  }
}