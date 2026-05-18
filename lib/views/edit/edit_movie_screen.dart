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
    for (var c in [_judul, _ringkasan, _poster, _sampul, _tanggal, _rating, _kategori, _trailer]) {
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
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: Get.back,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.delete_rounded, color: AppTheme.errorColor),
              onPressed: _showDeleteDialog,
              tooltip: 'Hapus Film',
            ),
          ),
        ],
      ),
      body: Obx(() => Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Informasi Film', Icons.info_rounded),
                      const SizedBox(height: 12),
                      _buildField(_judul, 'Judul Film', Icons.title_rounded,
                          validator: (v) => v!.isEmpty ? 'Judul wajib diisi' : null),
                      const SizedBox(height: 12),
                      _buildField(_ringkasan, 'Ringkasan', Icons.description_rounded,
                          maxLines: 4,
                          validator: (v) => v!.isEmpty ? 'Ringkasan wajib diisi' : null),
                      const SizedBox(height: 12),
                      _buildField(_kategori, 'Kategori', Icons.local_movies_rounded,
                          validator: (v) => v!.isEmpty ? 'Kategori wajib diisi' : null),
                      const SizedBox(height: 20),
                      _sectionLabel('Media', Icons.perm_media_rounded),
                      const SizedBox(height: 12),
                      _buildField(_poster, 'URL Poster', Icons.image_rounded,
                          validator: (v) => v!.isEmpty ? 'URL Poster wajib diisi' : null),
                      const SizedBox(height: 12),
                      _buildField(_sampul, 'URL Sampul', Icons.photo_library_rounded),
                      const SizedBox(height: 12),
                      _buildField(_trailer, 'URL Trailer', Icons.play_circle_rounded),
                      const SizedBox(height: 20),
                      _sectionLabel('Detail Rilis', Icons.calendar_month_rounded),
                      const SizedBox(height: 12),
                      _buildDatePicker(_tanggal, 'Tanggal Rilis'),
                      const SizedBox(height: 12),
                      _buildField(_rating, 'Rating (0-10)', Icons.star_rounded,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v!.isEmpty) return 'Rating wajib diisi';
                            final val = double.tryParse(v);
                            if (val == null || val < 0 || val > 10) return 'Masukkan angka 0-10';
                            return null;
                          }),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: _filmController.isLoading.value ? null : _update,
                          icon: _filmController.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.check_circle_rounded),
                          label: Text(
                            _filmController.isLoading.value ? 'Menyimpan...' : 'Simpan Perubahan',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              if (_filmController.isLoading.value)
                Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
                ),
            ],
          )),
    );
  }

  Widget _sectionLabel(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryLight),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.primaryLight,
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            thickness: 1,
          ),
        ),
      ],
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
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 20),
        filled: true,
        fillColor: AppTheme.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppTheme.textHint.withValues(alpha: 0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.errorColor, width: 1),
        ),
        labelStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDatePicker(TextEditingController c, String label) {
    return TextFormField(
      controller: c,
      readOnly: true,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.tryParse(c.text) ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) => Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(primary: AppTheme.primaryColor),
            ),
            child: child!,
          ),
        );
        if (picked != null) {
          c.text =
              "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        }
      },
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Pilih tanggal rilis',
        prefixIcon: const Icon(Icons.calendar_today_rounded, color: AppTheme.primaryColor, size: 20),
        suffixIcon: const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.textHint),
        filled: true,
        fillColor: AppTheme.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppTheme.textHint.withValues(alpha: 0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: AppTheme.textHint, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (v) => v!.isEmpty ? 'Tanggal rilis wajib diisi' : null,
    );
  }

  void _showDeleteDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: AppTheme.errorColor, size: 24),
            SizedBox(width: 8),
            Text('Hapus Film', style: TextStyle(color: AppTheme.textPrimary, fontSize: 18)),
          ],
        ),
        content: Text(
          'Yakin ingin menghapus "${widget.film.judul}"?\nTindakan ini tidak bisa dibatalkan.',
          style: const TextStyle(color: AppTheme.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Batal', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _filmController.deleteFilm(widget.film.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}