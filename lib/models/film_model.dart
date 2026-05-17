class FilmModel {
  final String id;
  final String judul;
  final String ringkasan;
  final String gambarPoster;
  final String gambarSampul;
  final String tanggalRilis; // Tetap String, tapi konversi saat parsing
  final String skorRating; // Tetap String, tapi konversi saat parsing
  final String kategori;
  final String urlTrailer;

  FilmModel({
    required this.id,
    required this.judul,
    required this.ringkasan,
    required this.gambarPoster,
    required this.gambarSampul,
    required this.tanggalRilis,
    required this.skorRating,
    required this.kategori,
    required this.urlTrailer,
  });

  // 🔥 PERBAIKI: FromJson dengan konversi tipe yang aman
  factory FilmModel.fromJson(Map<String, dynamic> json) {
    return FilmModel(
      id: json['id']?.toString() ?? '',
      judul: json['judul']?.toString() ?? '',
      ringkasan: json['ringkasan']?.toString() ?? '',
      gambarPoster: json['gambar_poster']?.toString() ?? '',
      gambarSampul: json['gambar_sampul']?.toString() ?? '',
      // 🔥 Konversi tanggal_rilis ke String dengan aman
      tanggalRilis: _convertToString(json['tanggal_rilis']),
      // 🔥 Konversi skor_rating ke String dengan aman
      skorRating: _convertToString(json['skor_rating']),
      kategori: json['kategori']?.toString() ?? '',
      urlTrailer: json['url_trailer']?.toString() ?? '',
    );
  }

  // Helper untuk konversi berbagai tipe ke String
  static String _convertToString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is int) return value.toString();
    if (value is double) return value.toString();
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'ringkasan': ringkasan,
      'gambar_poster': gambarPoster,
      'gambar_sampul': gambarSampul,
      'tanggal_rilis': tanggalRilis,
      'skor_rating': skorRating,
      'kategori': kategori,
      'url_trailer': urlTrailer,
    };
  }
}
