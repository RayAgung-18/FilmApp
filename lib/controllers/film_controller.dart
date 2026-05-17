import 'package:get/get.dart';

import '../models/film_model.dart';
import '../services/film_service.dart';

class FilmController extends GetxController {

  final FilmService service = FilmService();

  var filmList = <FilmModel>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    fetchFilms();
    super.onInit();
  }

  Future<void> fetchFilms() async {

    try {

      isLoading.value = true;

      final response = await service.getFilms();

      print(response.body);

      if (response.statusCode == 200) {

        if (response.body != null) {

          List<dynamic> data = response.body;

          filmList.value = data
              .map((e) => FilmModel.fromJson(e))
              .toList();
        }
      }

    } catch (e) {

      print(e);

      Get.snackbar(
        'Error',
        e.toString(),
      );

    } finally {

      isLoading.value = false;
    }
  }
}