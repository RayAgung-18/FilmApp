import 'dart:convert';
import 'package:http/http.dart' as http;

class FilmService {
  final String baseUrl = 'https://68ff8dfbe02b16d1753e765d.mockapi.io/film';

  // GET ALL FILM - return List<dynamic>
  Future<List<dynamic>> getFilms() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print('GET status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal memuat film: ${response.statusCode}');
      }
    } catch (e) {
      print('Error GET: $e');
      throw Exception('Error: $e');
    }
  }

  // ADD FILM - return Map<String, dynamic>
  Future<Map<String, dynamic>> addFilm(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      print('POST status: ${response.statusCode}');

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal menambah film: ${response.statusCode}');
      }
    } catch (e) {
      print('Error POST: $e');
      throw Exception('Error: $e');
    }
  }

  // UPDATE FILM - return Map<String, dynamic>
  Future<Map<String, dynamic>> updateFilm(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      print('PUT status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal mengupdate film: ${response.statusCode}');
      }
    } catch (e) {
      print('Error PUT: $e');
      throw Exception('Error: $e');
    }
  }

  // DELETE FILM - return void
  Future<void> deleteFilm(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      print('DELETE status: ${response.statusCode}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Gagal menghapus film: ${response.statusCode}');
      }
    } catch (e) {
      print('Error DELETE: $e');
      throw Exception('Error: $e');
    }
  }
}