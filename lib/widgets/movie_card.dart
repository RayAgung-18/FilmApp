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
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster dengan overlay gradient
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: film.gambarPoster,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 150,
                      color: AppTheme.surfaceColor,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 150,
                      color: AppTheme.surfaceColor,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image_rounded, color: AppTheme.textHint, size: 32),
                          SizedBox(height: 4),
                          Text('No Image', style: TextStyle(color: AppTheme.textHint, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ),
                // Gradient overlay bawah
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppTheme.cardColor,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Badge rating
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.goldColor.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, size: 12, color: AppTheme.goldColor),
                        const SizedBox(width: 3),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.goldColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Info film
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    film.judul,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    film.kategori.isNotEmpty ? film.kategori : 'Uncategorized',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _iconButton(
                        Icons.edit_rounded,
                        AppTheme.primaryColor,
                        () => Get.to(() => EditMovieScreen(film: film)),
                      ),
                      const SizedBox(width: 6),
                      _iconButton(
                        Icons.delete_rounded,
                        AppTheme.errorColor,
                        () => _showDeleteDialog(context),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showDetailDialog(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.primaryColor.withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                          ),
                          child: const Text(
                            'Detail',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.primaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    final rating = double.tryParse(film.skorRating) ?? 0.0;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: AppTheme.cardColor,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover image
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: film.gambarSampul.isNotEmpty
                          ? film.gambarSampul
                          : film.gambarPoster,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        height: 200,
                        color: AppTheme.surfaceColor,
                        child: const Icon(Icons.movie_rounded, color: AppTheme.textHint, size: 48),
                      ),
                    ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [AppTheme.cardColor, Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                    // Close button
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        film.judul,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Chips info
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _infoChip(Icons.star_rounded, rating.toStringAsFixed(1), AppTheme.goldColor),
                          _infoChip(Icons.local_movies_rounded, film.kategori, AppTheme.primaryLight),
                          _infoChip(Icons.calendar_month_rounded, film.tanggalRilis, AppTheme.textSecondary),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Sinopsis
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.article_rounded, size: 16, color: AppTheme.primaryLight),
                                SizedBox(width: 6),
                                Text(
                                  'Sinopsis',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              film.ringkasan.isNotEmpty ? film.ringkasan : 'Tidak ada sinopsis.',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                height: 1.6,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tombol trailer
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: film.urlTrailer.isNotEmpty
                              ? () => Get.to(() => TrailerPlayerScreen(url: film.urlTrailer))
                              : null,
                          icon: Icon(
                            film.urlTrailer.isNotEmpty
                                ? Icons.play_circle_filled_rounded
                                : Icons.play_disabled,
                            size: 22,
                          ),
                          label: Text(
                            film.urlTrailer.isNotEmpty ? 'Putar Trailer' : 'Trailer Tidak Tersedia',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            foregroundColor: Colors.white,
                            backgroundColor: film.urlTrailer.isNotEmpty
                                ? AppTheme.primaryColor
                                : AppTheme.textHint,
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Tombol edit
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                Get.to(() => EditMovieScreen(film: film));
                              },
                              icon: const Icon(Icons.edit_rounded, size: 18),
                              label: const Text('Edit Film'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryLight,
                                side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.5)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _showDeleteDialog(context);
                              },
                              icon: const Icon(Icons.delete_rounded, size: 18),
                              label: const Text('Hapus'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.errorColor,
                                side: BorderSide(color: AppTheme.errorColor.withValues(alpha: 0.5)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: AppTheme.errorColor, size: 24),
            SizedBox(width: 8),
            Text('Hapus Film', style: TextStyle(color: AppTheme.textPrimary, fontSize: 18)),
          ],
        ),
        content: Text(
          'Yakin ingin menghapus "${film.judul}"?\nTindakan ini tidak bisa dibatalkan.',
          style: const TextStyle(color: AppTheme.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Batal', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteFilm(film.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Hapus'),
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
      appBar: AppBar(
        title: const Text('Trailer Film'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: Get.back,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor.withValues(alpha: 0.15),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.play_circle_filled_rounded,
                  size: 64,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'URL Trailer',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  url,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.primaryLight,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Get.snackbar(
                    'Info',
                    'Trailer akan diintegrasi anggota 3',
                    backgroundColor: AppTheme.surfaceColor,
                    colorText: AppTheme.textPrimary,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 16,
                  ),
                  icon: const Icon(Icons.open_in_browser_rounded),
                  label: const Text(
                    'Buka di Browser',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}