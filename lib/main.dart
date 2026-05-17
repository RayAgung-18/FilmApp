import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/film_controller.dart';
import 'views/add/add_movie_screen.dart';
import 'views/edit/edit_movie_screen.dart';
import 'models/film_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Movie App - Anggota 4',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(FilmController(), permanent: true);
      }),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// HOME SCREEN UNTUK TESTING CRUD
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FilmController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎬 Movie App'),
        centerTitle: true,
        actions: [
          // Tombol refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchFilms(),
            tooltip: 'Refresh',
          ),
          // Tombol info
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'Info',
          ),
        ],
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value && controller.filmList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.redAccent),
                SizedBox(height: 16),
                Text('Memuat film...', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        // Error state
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchFilms(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (controller.filmList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.movie, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Belum Ada Film',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Klik tombol + untuk menambah film',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.to(() => const AddMovieScreen()),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Film'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          );
        }

        // List film
        return RefreshIndicator(
          onRefresh: () => controller.fetchFilms(),
          color: Colors.redAccent,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.filmList.length,
            itemBuilder: (context, index) {
              final film = controller.filmList[index];
              return _buildFilmCard(film, controller);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddMovieScreen()),
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilmCard(FilmModel film, FilmController controller) {
    // Parse rating ke double untuk ditampilkan
    final rating = double.tryParse(film.skorRating) ?? 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showDetailDialog(Get.context!, film),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: film.gambarPoster.isNotEmpty
                    ? Image.network(
                        film.gambarPoster,
                        width: 70,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 70,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 30),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 70,
                            height: 100,
                            color: Colors.grey[200],
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 70,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.movie, size: 30),
                      ),
              ),
              const SizedBox(width: 12),

              // Info film
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      film.judul,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.category,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            film.kategori,
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Tanggal rilis
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          film.tanggalRilis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Action buttons
                    Row(
                      children: [
                        // Edit button
                        ElevatedButton.icon(
                          onPressed: () =>
                              Get.to(() => EditMovieScreen(film: film)),
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Delete button
                        ElevatedButton.icon(
                          onPressed: () =>
                              _showDeleteDialog(Get.context!, film, controller),
                          icon: const Icon(Icons.delete, size: 16),
                          label: const Text('Hapus'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            textStyle: const TextStyle(fontSize: 12),
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
    );
  }

  void _showDetailDialog(BuildContext context, FilmModel film) {
    final rating = double.tryParse(film.skorRating) ?? 0.0;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner/Sampul
              if (film.gambarSampul.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    film.gambarSampul,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      film.judul,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rating & Kategori
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, size: 16),
                              const SizedBox(width: 4),
                              Text(rating.toString()),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(film.kategori),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(film.tanggalRilis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Ringkasan
                    const Text(
                      'Sinopsis',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(film.ringkasan, style: const TextStyle(height: 1.5)),

                    const SizedBox(height: 16),

                    // Trailer button
                    if (film.urlTrailer.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Buka URL trailer
                            Get.to(
                              () => TrailerPlayerScreen(url: film.urlTrailer),
                            );
                          },
                          icon: const Icon(Icons.play_circle),
                          label: const Text('Putar Trailer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
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

  void _showDeleteDialog(
    BuildContext context,
    FilmModel film,
    FilmController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Film'),
        content: Text('Yakin ingin menghapus "${film.judul}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteFilm(film.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('📱 Tentang Aplikasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Anggota 4 - CRUD CREATE & UPDATE'),
            const SizedBox(height: 8),
            Text('📦 Tugas:'),
            const Text(
              '• Tambah Film (Create)',
              style: TextStyle(fontSize: 12),
            ),
            const Text('• Edit Film (Update)', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            Text('📁 API: MockAPI'),
            Text('🔧 Framework: Flutter + GetX'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Tutup')),
        ],
      ),
    );
  }
}

// Screen untuk memutar trailer (sederhana)
class TrailerPlayerScreen extends StatelessWidget {
  final String url;
  const TrailerPlayerScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trailer Film'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle, size: 80, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'URL Trailer:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                url,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Bisa ditambahkan webview atau launch URL
                Get.snackbar(
                  'Info',
                  'Fitur trailer akan terintegrasi dengan anggota 3',
                );
              },
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Buka di Browser'),
            ),
          ],
        ),
      ),
    );
  }
}
