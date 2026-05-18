import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/film_controller.dart';
import '../../models/film_model.dart';
import '../../theme/app_theme.dart';

class EditMovieScreen extends StatefulWidget {
  final FilmModel film;
  const EditMovieScreen({super.key, required this.film});

  @override
  State<EditMovieScreen> createState() => _EditMovieScreenState();
}

class _EditMovieScreenState extends State<EditMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final FilmController _filmController = Get.find();

  late TextEditingController _judul;
  late TextEditingController _ringkasan;
  late TextEditingController _poster;
  late TextEditingController _sampul;
  late TextEditingController _tanggal;
  late TextEditingController _rating;
  late TextEditingController _kategori;
  late TextEditingController _trailer;

  @override
  void initState() {
    super.initState();
    _judul = TextEditingController(text: widget.film.judul);
    _ringkasan = TextEditingController(text: widget.film.ringkasan);
    _poster = TextEditingController(text: widget.film.gambarPoster);
    _sampul = TextEditingController(text: widget.film.gambarSampul);
    _tanggal = TextEditingController(text: widget.film.tanggalRilis);
    _rating = TextEditingController(text: widget.film.skorRating);
    _kategori = TextEditingController(text: widget.film.kategori);
    _trailer = TextEditingController(text: widget.film.urlTrailer);
  }

  @override
  void dispose() {
    for (var c in [
      _judul,
      _ringkasan,
      _poster,
      _sampul,
      _tanggal,
      _rating,
      _kategori,
      _trailer
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _update() async {
    if (_formKey.currentState!.validate()) {
      await _filmController.updateFilm(
        widget.film.id,
        FilmModel(
          id: widget.film.id,
          judul: _judul.text.trim(),
          ringkasan: _ringkasan.text.trim(),
          gambarPoster: _poster.text.trim(),
          gambarSampul: _sampul.text.trim(),
          tanggalRilis: _tanggal.text,
          skorRating: _rating.text,
          kategori: _kategori.text.trim(),
          urlTrailer: _trailer.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Edit Film'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(),
          ),
        ],
      ),
      body: Obx(() => Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                color: AppTheme.cardColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildField(_judul, 'Judul Film', Icons.title,
                          validator: (v) => v!.isEmpty ? 'Judul wajib' : null),
                      const SizedBox(height: 16),
                      _buildField(_ringkasan, 'Ringkasan', Icons.description,
                          maxLines: 4,
                          validator: (v) => v!.isEmpty ? 'Ringkasan wajib' : null),
                      const SizedBox(height: 16),
                      _buildField(_poster, 'URL Poster', Icons.image,
                          validator: (v) => v!.isEmpty ? 'URL Poster wajib' : null),
                      const SizedBox(height: 16),
                      _buildField(_sampul, 'URL Sampul', Icons.photo_library),
                      const SizedBox(height: 16),
                      _buildDatePicker(_tanggal, 'Tanggal Rilis'),
                      const SizedBox(height: 16),
                      _buildField(_rating, 'Rating (0-10)', Icons.star,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v!.isEmpty) return 'Rating wajib';
                            final val = double.tryParse(v);
                            if (val == null || val < 0 || val > 10)
                              return '0-10';
                            return null;
                          }),
                      const SizedBox(height: 16),
                      _buildField(_kategori, 'Kategori', Icons.category,
                          validator: (v) => v!.isEmpty ? 'Kategori wajib' : null),
                      const SizedBox(height: 16),
                      _buildField(_trailer, 'URL Trailer', Icons.play_circle),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              _filmController.isLoading.value ? null : _update,
                          child: _filmController.isLoading.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : const Text('UPDATE FILM'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_filmController.isLoading.value)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      )),
    );
  }

  Widget _buildField(
    TextEditingController c,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: c,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        filled: true,
        fillColor: AppTheme.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppTheme.primaryColor, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppTheme.textSecondary),
      ),
    );
  }

  Widget _buildDatePicker(TextEditingController c, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: c,
          readOnly: true,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) => Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                      primary: AppTheme.primaryColor),
                ),
                child: child!,
              ),
            );
            if (picked != null) {
              c.text =
                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
            }
          },
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'YYYY-MM-DD',
            prefixIcon: Icon(Icons.calendar_today,
                color: AppTheme.primaryColor),
            suffixIcon: Icon(Icons.arrow_drop_down, color: AppTheme.textHint),
            filled: true,
            fillColor: AppTheme.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppTheme.primaryColor, width: 1.5),
            ),
            hintStyle: const TextStyle(color: AppTheme.textHint),
          ),
          validator: (v) => v!.isEmpty ? 'Tanggal rilis wajib' : null,
        ),
      ],
    );
  }

  void _showDeleteDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Film'),
        content: Text('Yakin ingin menghapus "${widget.film.judul}"?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              _filmController.deleteFilm(widget.film.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}