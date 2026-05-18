import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/film_model.dart';
import '../services/film_service.dart';

class FilmController extends GetxController {
  final FilmService service = FilmService();

  var filmList = <FilmModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // 🔥 VARIABEL CADANGAN (SOLUSI DEBUGGING)
  // Digunakan untuk menyimpan salinan data asli dari API dosen.
  // Ini mencegah list film "habis" atau macet saat kamu menghapus huruf di kolom pencarian.
  var _allFilmsBackup = <FilmModel>[];

  @override
  void onInit() {
    super.onInit();
    fetchFilms();
  }

  // 📖 READ - MENGAMBIL SEMUA FILM DARI API
  Future<void> fetchFilms() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Mengambil data dari server melalui service
      final response = await service.getFilms();

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;

        if (body != null && body is List) {
          final List<dynamic> data = body;
          filmList.value = data
              .map((e) {
                try {
                  return FilmModel.fromJson(e);
                } catch (e) {
                  print('Gagal merubah data json ke model: $e');
                  return null;
                }
              })
              .whereType<FilmModel>()
              .toList();
          
          // 🔥 SIMPAN SALINAN DATA ASLI
          // Setiap kali berhasil mengambil data dari API, masukkan juga ke variabel cadangan
          _allFilmsBackup = List.from(filmList);

          print('Berhasil memuat ${filmList.length} film');
        } else {
          filmList.value = [];
          _allFilmsBackup = [];
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

  // ✨ CREATE - TAMBAH FILM BARU
  Future<void> addFilm(FilmModel film) async {
    try {
      isLoading.value = true;

      final response = await service.addFilm(film.toJson());
      print('Add response status: ${response.statusCode}');
      print('Add response body: ${response.body}');

      if (response.statusCode == 201) {
        final body = response.body;
        FilmModel newFilm;

        if (body != null && body is Map<String, dynamic>) {
          newFilm = FilmModel.fromJson(body);
        } else {
          newFilm = film;
        }

        // Masukkan data baru ke baris paling atas di list aktif
        filmList.insert(0, newFilm);
        // 🔥 Masukkan juga ke list cadangan agar film baru bisa ikut dicari langsung
        _allFilmsBackup.insert(0, newFilm);

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

  // ✏️ UPDATE - EDIT DATA FILM
  Future<void> updateFilm(String id, FilmModel film) async {
    try {
      isLoading.value = true;

      final response = await service.updateFilm(id, film.toJson());
      print('Update response status: ${response.statusCode}');
      print('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;
        FilmModel updatedFilm = film;

        if (body != null && body is Map<String, dynamic>) {
          updatedFilm = FilmModel.fromJson(body);
        }

        // Perbarui data pada list film yang sedang tampil aktif
        final index = filmList.indexWhere((f) => f.id == id);
        if (index != -1) {
          filmList[index] = updatedFilm;
        }

        // 🔥 Perbarui juga data pada list cadangan master agar hasil pencarian sinkron
        final backupIndex = _allFilmsBackup.indexWhere((f) => f.id == id);
        if (backupIndex != -1) {
          _allFilmsBackup[backupIndex] = updatedFilm;
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

      final response = await service.deleteFilm(id);
      print('Delete response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Hapus film dari daftar list aktif
        filmList.removeWhere((film) => film.id == id);
        // 🔥 Hapus juga dari daftar cadangan master
        _allFilmsBackup.removeWhere((film) => film.id == id);

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

  // 🔍 SEARCH - CARI FILM (VERSI FIX)
  void searchFilms(String query) {
    if (query.isEmpty) {
      // 🔥 Jika kolom pencarian kosong, kembalikan isi list dari data cadangan asli tanpa hit API ulang
      filmList.value = List.from(_allFilmsBackup);
    } else {
      // 🔥 Lakukan filter pencarian bersumber dari data cadangan master agar hasilnya selalu akurat
      final filtered = _allFilmsBackup.where((film) {
        return film.judul.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filmList.value = filtered;
    }
  }
}