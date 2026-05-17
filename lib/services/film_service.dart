import 'package:get/get.dart';

class FilmService extends GetConnect {

  final String baseUrl =
      'https://68ff8dfbe02b16d1753e765d.mockapi.io/film';

  // GET ALL FILM
  Future<Response> getFilms() async {
    return await get(baseUrl);
  }

  // ADD FILM
  Future<Response> addFilm(Map<String, dynamic> data) async {
    return await post(baseUrl, data);
  }

  // UPDATE FILM
  Future<Response> updateFilm(
      String id,
      Map<String, dynamic> data,
      ) async {
    return await put('$baseUrl/$id', data);
  }

  // DELETE FILM
  Future<Response> deleteFilm(String id) async {
    return await delete('$baseUrl/$id');
  }
}