import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/film_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/movie_card.dart';
import '../add/add_movie_screen.dart';
import '../../widgets/loading_animation.dart';
import '../../widgets/empty_state.dart';
import '../search/search_movie_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi atau mencari FilmController yang mengelola data film
    final controller = Get.find<FilmController>();
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.movie_filter_rounded, color: AppTheme.primaryColor, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('Movie App'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.to(() => const SearchMovieScreen()),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: controller.fetchFilms,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.filmList.isEmpty) {
          return const LoadingAnimation();
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return _errorView(controller);
        }
        if (controller.filmList.isEmpty) {
          return const EmptyState();
        }

        // 4. Kondisi normal saat data film berhasil dimuat sepenuhnya
        return RefreshIndicator(
          onRefresh: controller.fetchFilms,
          color: AppTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Text(
                        '${controller.filmList.length} Film',
                        style: const TextStyle(
                          color: AppTheme.textHint,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount(context),
                    mainAxisExtent: 245,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => MovieCard(
                      film: controller.filmList[i],
                      controller: controller,
                    ),
                    childCount: controller.filmList.length,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddMovieScreen()),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Film', style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 4,
      ),
    );
  }

  // Fungsi pembantu untuk menentukan jumlah kolom grid berdasarkan lebar layar (Responsif)
  int _crossAxisCount(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    if (w < 600) return 2;  // Layar HP (Lebar < 600): 2 Kolom
    if (w < 1200) return 3; // Layar Tablet (Lebar < 1200): 3 Kolom
    return 4;               // Layar Monitor/Web (Lebar > 1200): 4 Kolom
  }

  // Komponen UI khusus yang muncul jika sistem mendeteksi adanya error
  Widget _errorView(FilmController controller) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.wifi_off_rounded, size: 48, color: AppTheme.errorColor),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gagal memuat data',
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                controller.errorMessage.value,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: controller.fetchFilms,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
}