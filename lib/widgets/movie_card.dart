import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/film_controller.dart';
import '../../models/film_model.dart';
import '../../theme/app_theme.dart';
import '../../views/edit/edit_movie_screen.dart';

class MovieCard extends StatelessWidget {
  final FilmModel film;
  final FilmController controller;

  const MovieCard({super.key, required this.film, required this.controller});

  @override
  Widget build(BuildContext context) {
    final rating = double.tryParse(film.skorRating) ?? 0.0;

    return GestureDetector(
      onTap: () => _showDetailDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: film.gambarPoster,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 180,
                  color: AppTheme.surfaceColor,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 180,
                  color: AppTheme.surfaceColor,
                  child: const Icon(Icons.broken_image, color: AppTheme.textHint),
                ),
              ),
            ),
            // Info film dengan padding lebih kecil
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    film.judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          _iconButton(Icons.edit, AppTheme.primaryColor, () => Get.to(() => EditMovieScreen(film: film))),
                          const SizedBox(width: 8),
                          _iconButton(Icons.delete_outline, AppTheme.errorColor, () => _showDeleteDialog(context)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    final rating = double.tryParse(film.skorRating) ?? 0.0;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppTheme.cardColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (film.gambarSampul.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: CachedNetworkImage(
                    imageUrl: film.gambarSampul,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(film.judul, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        _infoChip(Icons.star, rating.toStringAsFixed(1), Colors.amber),
                        _infoChip(Icons.category, film.kategori, null),
                        _infoChip(Icons.calendar_today, film.tanggalRilis, null),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Sinopsis', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    const SizedBox(height: 8),
                    Text(film.ringkasan, style: const TextStyle(color: AppTheme.textSecondary, height: 1.4)),
                    const SizedBox(height: 20),
                    if (film.urlTrailer.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Get.to(() => TrailerPlayerScreen(url: film.urlTrailer)),
                          icon: const Icon(Icons.play_circle),
                          label: const Text('Putar Trailer'),
                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color? color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? AppTheme.textHint),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('Hapus Film', style: TextStyle(color: AppTheme.textPrimary)),
        content: Text('Yakin ingin menghapus "${film.judul}"?', style: const TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal', style: TextStyle(color: AppTheme.textHint))),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteFilm(film.id);
            },
            child: const Text('Hapus', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}

class TrailerPlayerScreen extends StatelessWidget {
  final String url;
  const TrailerPlayerScreen({super.key, required this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(title: const Text('Trailer Film')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_filled, size: 80, color: AppTheme.primaryColor),
            const SizedBox(height: 16),
            const Text('URL Trailer:', style: TextStyle(color: AppTheme.textPrimary)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(url, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.primaryColor)),
            ),
            ElevatedButton.icon(
              onPressed: () => Get.snackbar('Info', 'Trailer akan diintegrasi anggota 3'),
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Buka di Browser'),
            ),
          ],
        ),
      ),
    );
  }
}