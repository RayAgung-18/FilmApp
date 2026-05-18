import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/film_controller.dart';
import 'theme/app_theme.dart';
import 'views/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Movie App',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(FilmController(), permanent: true);
      }),
      home: const HomePage(), // ← pakai HomePage redesign
    );
  }
}