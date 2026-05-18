import 'package:get/get.dart';

class FilmService extends GetConnect {

  final String url =
      'https://68ff8dfbe02b16d1753e765d.mockapi.io/film';

  Future<Response> getFilms() async {

    final response = await get(url);

    print("STATUS : ${response.statusCode}");
    print("BODY : ${response.body}");

    return response;
  }
}