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
        title: const Text('Movie App'),
        actions: [
          // Tombol Kaca Pembesar untuk berpindah ke halaman pencarian film
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.to(() => const SearchMovieScreen()),
          ),
          // Tombol Refresh untuk memuat ulang data langsung dari API dosen
          IconButton(
            onPressed: controller.fetchFilms, 
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        // 1. Kondisi saat aplikasi baru dibuka, sedang loading, dan list film masih kosong
        if (controller.isLoading.value && controller.filmList.isEmpty) return const LoadingAnimation();
        
        // 2. Kondisi jika terjadi error/gagal terhubung ke API dosen
        if (controller.errorMessage.value.isNotEmpty) return _errorView(controller);
        
        // 3. Kondisi jika data berhasil diambil tapi ternyata memang tidak ada film di server
        if (controller.filmList.isEmpty) return const EmptyState();

        // 4. Kondisi normal saat data film berhasil dimuat sepenuhnya
        return RefreshIndicator(
          onRefresh: controller.fetchFilms, // Fitur geser ke bawah (pull to refresh)
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount(context), // Jumlah kolom otomatis menyesuaikan ukuran layar
                mainAxisExtent: 240, // Batasan tinggi maksimal untuk setiap kartu film
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.filmList.length,
              itemBuilder: (_, i) => MovieCard(film: controller.filmList[i], controller: controller),
            ),
          ),
        );
      }),
      // Tombol melayang di kanan bawah untuk menambah film baru
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddMovieScreen()),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                controller.errorMessage.value, 
                style: const TextStyle(color: AppTheme.errorColor), 
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            // Tombol untuk mencoba menembak ulang API server dosen
            ElevatedButton.icon(
              onPressed: controller.fetchFilms, 
              icon: const Icon(Icons.refresh), 
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
}