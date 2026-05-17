import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/film_controller.dart';
import '../../models/film_model.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final FilmController _filmController = Get.find();

  // Controllers untuk input
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _ringkasanController = TextEditingController();
  final TextEditingController _gambarPosterController = TextEditingController();
  final TextEditingController _gambarSampulController = TextEditingController();
  final TextEditingController _tanggalRilisController = TextEditingController();
  final TextEditingController _skorRatingController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _urlTrailerController = TextEditingController();

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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newFilm = FilmModel(
        id: '', // ID akan di-generate oleh API
        judul: _judulController.text.trim(),
        ringkasan: _ringkasanController.text.trim(),
        gambarPoster: _gambarPosterController.text.trim(),
        gambarSampul: _gambarSampulController.text.trim(),
        tanggalRilis: _tanggalRilisController.text,
        skorRating: _skorRatingController.text,
        kategori: _kategoriController.text.trim(),
        urlTrailer: _urlTrailerController.text.trim(),
      );

      await _filmController.addFilm(newFilm);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '✨ Tambah Film Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
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
                    // Judul Film
                    _buildTextField(
                      controller: _judulController,
                      label: 'Judul Film',
                      hint: 'Contoh: Avengers: Endgame',
                      icon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Judul film harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Ringkasan / Sinopsis
                    _buildTextField(
                      controller: _ringkasanController,
                      label: 'Ringkasan / Sinopsis',
                      hint: 'Ceritakan tentang film ini...',
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

                    // URL Poster
                    _buildTextField(
                      controller: _gambarPosterController,
                      label: 'URL Gambar Poster',
                      hint: 'https://...',
                      icon: Icons.image,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'URL poster harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // URL Sampul (Banner)
                    _buildTextField(
                      controller: _gambarSampulController,
                      label: 'URL Gambar Sampul (Banner)',
                      hint: 'https://...',
                      icon: Icons.photo_library,
                    ),
                    const SizedBox(height: 16),

                    // Tanggal Rilis
                    _buildDatePickerField(
                      controller: _tanggalRilisController,
                      label: 'Tanggal Rilis',
                    ),
                    const SizedBox(height: 16),

                    // Skor Rating
                    _buildTextField(
                      controller: _skorRatingController,
                      label: 'Skor Rating',
                      hint: 'Contoh: 8.5',
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

                    // Kategori
                    _buildTextField(
                      controller: _kategoriController,
                      label: 'Kategori',
                      hint: 'Contoh: Action, Drama, Comedy',
                      icon: Icons.category,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kategori harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // URL Trailer
                    _buildTextField(
                      controller: _urlTrailerController,
                      label: 'URL Trailer YouTube',
                      hint: 'https://youtube.com/...',
                      icon: Icons.play_circle,
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _filmController.isLoading.value
                            ? null
                            : _submitForm,
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
                                '✨ SIMPAN FILM',
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

            // Loading Overlay
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
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildDatePickerField({
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Colors.redAccent,
                      onPrimary: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              controller.text =
                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
            }
          },
          decoration: InputDecoration(
            hintText: 'YYYY-MM-DD',
            prefixIcon: const Icon(Icons.calendar_today),
            suffixIcon: const Icon(Icons.arrow_drop_down),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Tanggal rilis harus diisi';
            }
            return null;
          },
        ),
      ],
    );
  }
}
