// loading_animation.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoadingAnimation extends StatelessWidget {
  final String? message;
  const LoadingAnimation({super.key, this.message});
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 36, height: 36, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppTheme.primaryColor)),
            const SizedBox(height: 16),
            Text(message ?? 'Memuat film...', style: const TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      );
}