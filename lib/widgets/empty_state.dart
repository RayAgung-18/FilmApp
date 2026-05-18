// empty_state.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../views/add/add_movie_screen.dart';

class EmptyState extends StatelessWidget {
  final String title, subtitle;
  final VoidCallback? onAddPressed;
  const EmptyState({super.key, this.title = 'Belum Ada Film', this.subtitle = 'Klik + untuk menambah', this.onAddPressed});
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_creation_outlined, size: 80, color: AppTheme.textHint),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAddPressed ?? () => Get.to(() => const AddMovieScreen()),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Film'),
            ),
          ],
        ),
      );
}