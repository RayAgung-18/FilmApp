import 'package:get/get.dart';

class FilmService extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.timeout = const Duration(seconds: 30);
  }

  Future<Response> getFilms() async {
    final response = await get(
      'https://68ff8dfbe02b16d1753e765d.mockapi.io/film',
    );
    print("GET STATUS : ${response.statusCode}");
    print("GET BODY : ${response.body}");
    return response;
  }

  Future<Response> addFilm(Map<String, dynamic> data) async {
    final response = await post(
      'https://68ff8dfbe02b16d1753e765d.mockapi.io/film',
      data,
    );
    print("POST STATUS : ${response.statusCode}");
    return response;
  }

  Future<Response> updateFilm(String id, Map<String, dynamic> data) async {
    final response = await put(
      'https://68ff8dfbe02b16d1753e765d.mockapi.io/film/$id',
      data,
    );
    print("PUT STATUS : ${response.statusCode}");
    return response;
  }

  Future<Response> deleteFilm(String id) async {
    final response = await delete(
      'https://68ff8dfbe02b16d1753e765d.mockapi.io/film/$id',
    );
    print("DELETE STATUS : ${response.statusCode}");
    return response;
  }
}
