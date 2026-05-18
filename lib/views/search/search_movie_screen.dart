import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/film_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/empty_state.dart';

class SearchMovieScreen extends StatefulWidget {
  const SearchMovieScreen({super.key});

  @override
  State<SearchMovieScreen> createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  // Mencari instance FilmController yang sudah berjalan di aplikasi
  final FilmController controller = Get.find<FilmController>();
  // Controller untuk mendeteksi apa yang diketik user di kolom pencarian
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mendengarkan setiap ada perubahan ketikan di kolom pencarian
    searchController.addListener(() {
      // Jalankan fungsi pencarian di controller secara real-time
      controller.searchFilms(searchController.text);
      // Memicu gambar ulang UI agar tombol 'X' (clear) muncul/hilang sesuai isi teks
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    // Hapus controller dari memori saat halaman ditutup agar tidak boros RAM
    searchController.dispose();
    // Reset kembali hasil pencarian agar saat kembali ke Home, semua film muncul lagi
    controller.searchFilms('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        title: const Text(
          'Cari Film',
          style: TextStyle(
            color: AppTheme.textPrimary, 
            fontWeight: FontWeight.bold,
          ),
        ),
        // Tombol kembali ke halaman sebelumnya
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Menggunakan komponen textfield custom yang sudah dibuat timmu
            CustomTextField(
              controller: searchController,
              label: 'Pencarian',
              hint: 'Ketik judul film...',
              prefixIcon: Icons.search,
              // Jika kolom teks tidak kosong, munculkan ikon silang (X) untuk menghapus teks
              suffixIcon: searchController.text.isNotEmpty ? Icons.clear : null,
              onSuffixTap: () {
                searchController.clear(); // Hapus semua teks di kolom pencarian
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              // Obx digunakan untuk memantau perubahan data pada filmList secara reaktif
              child: Obx(() {
                // Tampilkan indikator loading jika proses pencarian/koneksi sedang sibuk
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primaryColor),
                  );
                }

                // Jika hasil pencarian tidak ditemukan di dalam list
                if (controller.filmList.isEmpty) {
                  return const EmptyState(
                    title: 'Film Tidak Ditemukan',
                    subtitle: 'Coba cari dengan kata kunci lain',
                  );
                }

                // Tampilan Grid jika film berhasil ditemukan
                return GridView.builder(
                  itemCount: controller.filmList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Menampilkan 2 kolom film sejajar
                    crossAxisSpacing: 14, // Jarak antar kolom kanan-kiri
                    mainAxisSpacing: 14, // Jarak antar baris atas-bawah
                    childAspectRatio: 0.66, // Mengatur rasio proporsi tinggi-lebar kartu film
                  ),
                  itemBuilder: (context, index) {
                    final film = controller.filmList[index];
                    // Menampilkan kartu film sesuai data hasil filter
                    return MovieCard(film: film, controller: controller);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}