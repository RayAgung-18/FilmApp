import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/film_controller.dart';
import '../../models/film_model.dart';

class EditMovieScreen extends StatefulWidget {
  final FilmModel film;
  const EditMovieScreen({super.key, required this.film});

  @override
  State<EditMovieScreen> createState() => _EditMovieScreenState();
}

class _EditMovieScreenState extends State<EditMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final FilmController _filmController = Get.find();

  late TextEditingController _judulController;
  late TextEditingController _ringkasanController;
  late TextEditingController _gambarPosterController;
  late TextEditingController _gambarSampulController;
  late TextEditingController _tanggalRilisController;
  late TextEditingController _skorRatingController;
  late TextEditingController _kategoriController;
  late TextEditingController _urlTrailerController;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.film.judul);
    _ringkasanController = TextEditingController(text: widget.film.ringkasan);
    _gambarPosterController = TextEditingController(
      text: widget.film.gambarPoster,
    );
    _gambarSampulController = TextEditingController(
      text: widget.film.gambarSampul,
    );
    _tanggalRilisController = TextEditingController(
      text: widget.film.tanggalRilis,
    );
    _skorRatingController = TextEditingController(text: widget.film.skorRating);
    _kategoriController = TextEditingController(text: widget.film.kategori);
    _urlTrailerController = TextEditingController(text: widget.film.urlTrailer);
  }

  @override
  void dispose() {
    _judulController.dispose();
    _ringkasanController.dispose();
    _gambarPosterController.dispose();
    _gambarSampulController.dispose();
    _tanggalRilisController.dispose();
    _skorRatingController.dispose();
    _kategoriController.dispose();
    _urlTrailerController.dispose();
    super.dispose();
  }

  Future<void> _updateFilm() async {
    if (_formKey.currentState!.validate()) {
      final updatedFilm = FilmModel(
        id: widget.film.id,
        judul: _judulController.text.trim(),
        ringkasan: _ringkasanController.text.trim(),
        gambarPoster: _gambarPosterController.text.trim(),
        gambarSampul: _gambarSampulController.text.trim(),
        tanggalRilis: _tanggalRilisController.text,
        skorRating: _skorRatingController.text,
        kategori: _kategoriController.text.trim(),
        urlTrailer: _urlTrailerController.text.trim(),
      );

      await _filmController.updateFilm(widget.film.id, updatedFilm);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '✏️ Edit Film',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteConfirmation(),
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _judulController,
                      label: 'Judul Film',
                      icon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Judul film harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _ringkasanController,
                      label: 'Ringkasan',
                      icon: Icons.description,
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ringkasan harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _gambarPosterController,
                      label: 'URL Poster',
                      icon: Icons.image,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'URL poster harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _gambarSampulController,
                      label: 'URL Sampul',
                      icon: Icons.photo_library,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _tanggalRilisController,
                      label: 'Tanggal Rilis',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _tanggalRilisController.text =
                              "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _skorRatingController,
                      label: 'Skor Rating',
                      icon: Icons.star,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Rating harus diisi';
                        }
                        final rating = double.tryParse(value);
                        if (rating == null || rating < 0 || rating > 10) {
                          return 'Rating harus antara 0 - 10';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _kategoriController,
                      label: 'Kategori',
                      icon: Icons.category,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kategori harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _urlTrailerController,
                      label: 'URL Trailer',
                      icon: Icons.play_circle,
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _filmController.isLoading.value
                            ? null
                            : _updateFilm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _filmController.isLoading.value
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                '✏️ UPDATE FILM',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_filmController.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  void _showDeleteConfirmation() {
    Get.defaultDialog(
      title: '⚠️ Hapus Film',
      middleText: 'Yakin ingin menghapus "${widget.film.judul}"?',
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        _filmController.deleteFilm(widget.film.id);
      },
    );
  }
}
