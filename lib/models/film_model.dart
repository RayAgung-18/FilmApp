class FilmModel {
  final String id;
  final String judul;
  final String ringkasan;
  final String gambarPoster;
  final String gambarSampul;
  final String tanggalRilis;
  final String skorRating;
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

  factory FilmModel.fromJson(Map<String, dynamic> json) {
    return FilmModel(
      id: json['id'].toString(),
      judul: json['judul'] ?? '',
      ringkasan: json['ringkasan'] ?? '',
      gambarPoster: json['gambar_poster'] ?? '',
      gambarSampul: json['gambar_sampul'] ?? '',
      tanggalRilis: json['tanggal_rilis'].toString(),
      skorRating: json['skor_rating'].toString(),
      kategori: json['kategori'] ?? '',
      urlTrailer: json['url_trailer'] ?? '',
    );
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