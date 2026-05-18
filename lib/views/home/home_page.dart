import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/film_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/movie_card.dart';
import '../add/add_movie_screen.dart';
import '../../widgets/loading_animation.dart';
import '../../widgets/empty_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FilmController>();
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Movie App'),
        actions: [IconButton(onPressed: controller.fetchFilms, icon: const Icon(Icons.refresh))],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.filmList.isEmpty) return const LoadingAnimation();
        if (controller.errorMessage.value.isNotEmpty) return _errorView(controller);
        if (controller.filmList.isEmpty) return const EmptyState();

        return RefreshIndicator(
          onRefresh: controller.fetchFilms,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount(context),
                mainAxisExtent: 240, 
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.filmList.length,
              itemBuilder: (_, i) => MovieCard(film: controller.filmList[i], controller: controller),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddMovieScreen()),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  int _crossAxisCount(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    if (w < 600) return 2;
    if (w < 1200) return 3;
    return 4;
  }

  Widget _errorView(FilmController controller) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(controller.errorMessage.value, style: const TextStyle(color: AppTheme.errorColor), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(onPressed: controller.fetchFilms, icon: const Icon(Icons.refresh), label: const Text('Coba Lagi')),
          ],
        ),
      );
}