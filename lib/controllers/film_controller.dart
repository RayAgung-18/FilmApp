import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/film_model.dart';
import '../services/film_service.dart';

class FilmController extends GetxController {
  final FilmService service = FilmService();

  var filmList = <FilmModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFilms();
  }

  // 📖 READ - FETCH ALL FILMS
  Future<void> fetchFilms() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 🔥 SEKARANG return Response, BUKAN langsung List
      final response = await service.getFilms();

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;

        // 🔥 body adalah List dari response
        if (body != null && body is List) {
          final List<dynamic> data = body;
          filmList.value = data
              .map((e) {
                try {
                  return FilmModel.fromJson(e);
                } catch (e) {
                  print('Error parsing film: $e');
                  return null;
                }
              })
              .whereType<FilmModel>()
              .toList();
          print('Berhasil memuat ${filmList.length} film');
        } else {
          filmList.value = [];
        }
      } else {
        throw Exception('Gagal memuat film: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error fetchFilms: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✨ CREATE - TAMBAH FILM
  Future<void> addFilm(FilmModel film) async {
    try {
      isLoading.value = true;

      // 🔥 SEKARANG return Response
      final response = await service.addFilm(film.toJson());
      print('Add response status: ${response.statusCode}');
      print('Add response body: ${response.body}');

      if (response.statusCode == 201) {
        final body = response.body;

        if (body != null && body is Map<String, dynamic>) {
          final newFilm = FilmModel.fromJson(body);
          filmList.insert(0, newFilm);
        } else {
          filmList.insert(0, film);
        }

        if (Get.previousRoute.isNotEmpty) {
          Get.back();
        }

        Get.snackbar(
          '✨ Sukses',
          'Film "${film.judul}" berhasil ditambahkan',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Gagal menambah film: ${response.statusCode}');
      }
    } catch (e) {
      print('Error addFilm: $e');
      Get.snackbar(
        '❌ Gagal',
        'Gagal menambah film: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✏️ UPDATE - EDIT FILM
  Future<void> updateFilm(String id, FilmModel film) async {
    try {
      isLoading.value = true;

      // 🔥 SEKARANG return Response
      final response = await service.updateFilm(id, film.toJson());
      print('Update response status: ${response.statusCode}');
      print('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;

        if (body != null && body is Map<String, dynamic>) {
          final updatedFilm = FilmModel.fromJson(body);

          final index = filmList.indexWhere((f) => f.id == id);
          if (index != -1) {
            filmList[index] = updatedFilm;
          }
        } else {
          final index = filmList.indexWhere((f) => f.id == id);
          if (index != -1) {
            filmList[index] = film;
          }
        }

        if (Get.previousRoute.isNotEmpty) {
          Get.back();
        }

        Get.snackbar(
          '✏️ Sukses',
          'Film berhasil diupdate',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Gagal mengupdate film: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updateFilm: $e');
      Get.snackbar(
        '❌ Gagal',
        'Gagal mengupdate film: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 🗑️ DELETE - HAPUS FILM
  Future<void> deleteFilm(String id) async {
    try {
      isLoading.value = true;

      // 🔥 SEKARANG return Response
      final response = await service.deleteFilm(id);
      print('Delete response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        filmList.removeWhere((film) => film.id == id);

        Get.snackbar(
          '🗑️ Sukses',
          'Film berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Gagal menghapus film: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleteFilm: $e');
      Get.snackbar(
        '❌ Gagal',
        'Gagal menghapus film: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 🔍 SEARCH - CARI FILM
  void searchFilms(String query) {
    if (query.isEmpty) {
      fetchFilms();
    } else {
      final filtered = filmList.where((film) {
        return film.judul.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filmList.value = filtered;
    }
  }
}
