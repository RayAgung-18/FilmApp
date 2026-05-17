import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/film_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final FilmController controller =
        Get.put(FilmController());

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Film App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Obx(() {

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.filmList.isEmpty) {
          return const Center(
            child: Text(
              'Data kosong',
            ),
          );
        }

        return ListView.builder(

          itemCount: controller.filmList.length,

          itemBuilder: (context, index) {

            final film = controller.filmList[index];

            return Container(

              margin: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),

              child: Row(

                children: [

                  // POSTER
                  ClipRRect(

                    borderRadius: BorderRadius.circular(20),

                    child: CachedNetworkImage(

                      imageUrl: film.gambarPoster,

                      width: 120,
                      height: 180,
                      fit: BoxFit.cover,

                      placeholder: (context, url) =>
                      const SizedBox(
                        width: 120,
                        height: 180,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),

                      errorWidget: (context, url, error) =>
                          Container(
                            width: 120,
                            height: 180,
                            color: Colors.grey,
                            child: const Icon(
                              Icons.broken_image,
                              size: 50,
                            ),
                          ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // INFO
                  Expanded(

                    child: Padding(

                      padding: const EdgeInsets.all(10),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Text(

                            film.judul,

                            maxLines: 2,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            film.kategori,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [

                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),

                              const SizedBox(width: 5),

                              Text(
                                film.skorRating,
                              ),

                            ],
                          ),

                          const SizedBox(height: 10),

                          Text(
                            film.ringkasan,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}