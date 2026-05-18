import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final String filmId;

  const BannerWidget({Key? key, required this.filmId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contoh: ambil gambar dari asset lokal
    return Image.asset(
      "assets/images/$filmId-banner.jpg", // ganti sesuai asset/URL
      fit: BoxFit.cover,
      height: 250,
      width: double.infinity,
    );
  }
}
